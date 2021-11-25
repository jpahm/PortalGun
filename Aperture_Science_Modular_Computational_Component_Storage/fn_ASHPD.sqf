// Copyright 2021 Sysroot/Eisenhorn

// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at

    // http://www.apache.org/licenses/LICENSE-2.0

// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

#include "macros.hpp"

// Set up disconnect EH if server
if (isServer) then {
	call PG_fnc_InitDisconnect;
};

// Don't run any of the rest of this code on a dedicated server, exit here
if (isDedicated) exitWith {};

// Init the local cam variables
missionNameSpace setVariable [format["PG_VAR_BLUE_CAM_%1", clientOwner], objNull];
missionNameSpace setVariable [format["PG_VAR_ORANGE_CAM_%1", clientOwner], objNull];

// Private globals (you shouldn't touch these unless you know what you're doing!)
PG_VAR_PORTAL_HEIGHT = 2; // 1.75
PG_VAR_PORTAL_WIDTH = 1.2; // 1
PG_VAR_PORTAL_HEIGHT_H = PG_VAR_PORTAL_HEIGHT/2;
PG_VAR_PORTAL_WIDTH_H = PG_VAR_PORTAL_WIDTH/2;
PG_VAR_PORTALS_LINKED = false;
PG_VAR_CAM_FOLLOW = false;
PG_VAR_ANIM_HANDLE = objNull;
PG_VAR_TP_CACHE = [];
PG_VAR_CROSSHAIR_HANDLE = objNull;
PG_VAR_CROSSHAIR_IMAGE = "EmptyCursor";
PG_VAR_GRABBING = false;
PG_VAR_GRABBED_OBJECT = objNull;
PG_VAR_PROJECTILE_TYPES = PG_VAR_PROJECTILE_TYPES_SETTING splitString ", ";
PG_VAR_GRAB_SS = objNull;
PG_VAR_GRAB_HANDLE = objNull;
PG_VAR_GRAB_PARTICLES = objNull;
PG_VAR_POTATO_SPEAKING = false;
PG_VAR_PORTAL_SURFACES = [objNull, objNull];

// Check whether portals already exist for this player (placed via Zeus, 3den, or createVehicle/createVehicleLocal) create them if not
if (isNil "PG_VAR_BLUE_PORTAL") then {
	PG_VAR_BLUE_PORTAL = "Portal" createVehicle [0,0,0];
	PG_VAR_BLUE_SPAWNED = false;
} else {
	PG_VAR_BLUE_SPAWNED = true;
};
if (isNil "PG_VAR_ORANGE_PORTAL") then {
	PG_VAR_ORANGE_PORTAL = "Portal" createVehicle [0,0,0];
	PG_VAR_ORANGE_SPAWNED = false;
} else {
	PG_VAR_ORANGE_SPAWNED = true;
}; 

// Create the sound sources for the portal ambiance
PG_VAR_BLUE_SS = createSoundSource ["PortalAmbientSource", PG_VAR_BLUE_PORTAL, [], 0];
PG_VAR_ORANGE_SS = createSoundSource ["PortalAmbientSource", PG_VAR_ORANGE_PORTAL, [], 0];

// Set the inner portals to the default noise texture and material
PG_VAR_BLUE_PORTAL setObjectTextureGlobal [1, PG_BLUE_NOISE_TEX];
PG_VAR_ORANGE_PORTAL setObjectTextureGlobal [1, PG_ORANGE_NOISE_TEX]; 
PG_VAR_BLUE_PORTAL setObjectMaterialGlobal [1, PG_BLUE_NOISE_MAT];
PG_VAR_ORANGE_PORTAL setObjectMaterialGlobal [1, PG_ORANGE_NOISE_MAT];

// Set the portal edges to the proper edge textures and materials
PG_VAR_BLUE_PORTAL setObjectTextureGlobal [0, PG_BLUE_EDGE_TEX]; 
PG_VAR_ORANGE_PORTAL setObjectTextureGlobal [0, PG_ORANGE_EDGE_TEX];
PG_VAR_BLUE_PORTAL setObjectMaterialGlobal [0, PG_BLUE_EDGE_MAT];
PG_VAR_ORANGE_PORTAL setObjectMaterialGlobal [0, PG_ORANGE_EDGE_MAT]; 

// Animate the edges and noise textures
PG_VAR_BLUE_PORTAL animateSource ["Portal_Flames_Source", 100000, 1];
PG_VAR_ORANGE_PORTAL animateSource ["Portal_Flames_Source", 100000, 1];
PG_VAR_BLUE_PORTAL animateSource ["Portal_Noise_Source", 100000, 1];
PG_VAR_ORANGE_PORTAL animateSource ["Portal_Noise_Source", 100000, 1];

// Init the portal gun mode with addonOptions settings if they're not already set
if (isNil "PG_VAR_INIT_SETTINGS") then {
	PG_VAR_PORTAL_GUN_MODE call PG_fnc_InitPortals;
};
[] call PG_fnc_UpdatePortals;
[] call PG_fnc_HandleWeaponSwitch;

// Handle shooting the portal gun, and creating/updating the portals accordingly
player addEventHandler ["Fired", {
	if ((_this#1) isKindOf ["ASHPD_MK_SUS_Base_F", configFile >> "CfgWeapons"]) then {
	
		// Keep ammo stocked if infinite ammo is enabled (only if there's already some ammo present)
		if (PG_VAR_INFINITE_AMMO_ENABLED) then {
			private _muzzle = currentMuzzle player;
			private _ammoCount = player ammo _muzzle;
			if (_ammoCount <= 1) then {
				player setAmmo [_muzzle, 3];
			} else {
				player setAmmo [_muzzle, _ammoCount + 1];
			};
		};
	
		// Only try to spawn portal if not grabbing anything
		if (!PG_VAR_GRABBING && {PG_VAR_CURRENT_PORTAL call PG_fnc_TrySpawnPortal}) then {
			if (PG_VAR_CURRENT_PORTAL isEqualTo PG_VAR_BLUE_PORTAL) then {
				[PG_VAR_BLUE_PORTAL, "portal_open_blue"] remoteExec ["PG_fnc_PlaySound"];
				PG_VAR_BLUE_SS setPosWorld (getPosWorld PG_VAR_BLUE_PORTAL);
				PG_VAR_BLUE_SPAWNED = true;
			} else {
				[PG_VAR_ORANGE_PORTAL, "portal_open_red"] remoteExec ["PG_fnc_PlaySound"];
				PG_VAR_ORANGE_SS setPosWorld (getPosWorld PG_VAR_ORANGE_PORTAL);
				PG_VAR_ORANGE_SPAWNED = true;
			};
			call PG_fnc_UpdatePortals;
		};
	};
}];

// Handle player respawn
player addMPEventHandler ["MPRespawn", {
	PG_VAR_INIT_SETTINGS call PG_fnc_InitPortals;
	[PG_VAR_BLUE_PORTAL, PG_VAR_ORANGE_PORTAL] remoteExecCall ["PG_fnc_RefreshPiP"];
}];

// Handle player being killed
player addMPEventHandler ["MPKilled", {
	if (PG_VAR_FIZZLE_ON_DEATH_ENABLED) then {
		[] call PG_fnc_Fizzle;
	};
}];

// For playing reactive potatOS dialog
player addEventHandler ["Hit", {
	params ["_unit", "_source", "_damage", "_instigator"];
	
	// Only play dialog if potatOS not disabled, not already speaking, and equipped
	if (
		!PG_VAR_POTATO_ENABLED || 
		{PG_VAR_POTATO_SPEAKING} || 
		{!((currentWeapon player) isEqualTo "ASHPD_MK_SUS_P")}
	) exitWith {};
	
	private _possibleLines = [objNull, 0.8];
	
	if (player getHitPointDamage "HitBody" >= 0.75) then { // React differently if player is close to death
		_possibleLines append [
			["potatos_not_good", "This is NOT good.", 0.05], 0.1,
			["potatos_odds", "I'm not going to lie to you, the odds are a million to one, and that's with some generous rounding.", 0.005, [[" ", 0.2], [",", 0.15], [".", 0.8]]], 0.1,
			["potatos_about_to_kill", "I get the impression he's about to kill us.", 0.01], 0.1,
			["potatos_laugh", "Heh heh heh heh heh heh heh"], 0.1,
			["potatos_trouble", "I think we're in trouble."], 0.1
		];
	} else {
		if (_instigator isEqualTo objNull || {_instigator isEqualTo player}) then { // Reactions if they hurt themselves
			_possibleLines append [
				["potatos_brain_damage", "You really do have brain damage, don't you?", 0.01, [[" ", 0.2], [",", 0.1], ["?", 0.8]]], 0.2,
				["potatos_slow_clap", "clap,.clap,.clap"], 0.2,
				["potatos_still_working", "clap,.clap,, good, that's still working.", 0.02, [[" ", 0.2], [",", 0.275], [".", 0.8]]], 0.2,
				["potatos_wow", "Wow."], 0.2
			];
		} else { // Reactions if something hurt them
			_possibleLines append [
				["potatos_burn_house", "BURN HIS HOUSE DOWN!"], 0.1,
				["potatos_yell", "Argh!"], 0.1,
				["potatos_uh_oh", "Uh oh."], 0.1,
				["potatos_hey_moron", "Hey, moron.", 0.05], 0.1
			];
		};
	};
	
	// Pick and play a random line from the pool, or don't play anything if objNull is picked
	private _randomLine = selectRandomWeighted _possibleLines;
	if (!(_randomLine isEqualTo objNull)) then {
		_randomLine spawn PG_fnc_SpeakPotato;
	};
}];

// Infrequently check if random potatOS dialog should play
[] spawn {
	while {true} do {
		// Add possible random dialog
		private _possibleLines = [
			objNull, 1.0, 
			["potatos_holding_up", "So, how are you holding up?"], 0.1,
			["potatos_wake_up", "Woah. Where are we? How long have I been out?", 0.005, [[" ", 0.2], [".", 0.3], ["?", 0.3]]], 0.1
		];
		// Pick and play a random line from the pool, or don't play anything if objNull is picked
		private _randomLine = selectRandomWeighted _possibleLines;
		if (!(_randomLine isEqualTo objNull)) then {
			_randomLine spawn PG_fnc_SpeakPotato;
		};
		// Wait anywhere from 5 to 10 minutes before trying again
		sleep (random [300, 450, 600]);
	};
};

// Swap portals on firemode switch
addUserActionEventHandler ["nextWeapon", "Activate", PG_fnc_SwapPortals];

// Handle switching weapons
addUserActionEventHandler ["SwitchPrimary", "Activate", {[true] call PG_fnc_HandleWeaponSwitch}];
addUserActionEventHandler ["SwitchSecondary", "Activate", {[false] call PG_fnc_HandleWeaponSwitch}];
addUserActionEventHandler ["SwitchHandgun", "Activate", {[false] call PG_fnc_HandleWeaponSwitch}];

// Handle toggling grab
addUserActionEventHandler ["fire", "Activate", PG_fnc_TryGrab];

// Handle player fizzling portals
addUserActionEventHandler ["deployWeaponAuto", "Activate", {
	if (PG_VAR_PLAYER_FIZZLE_ENABLED && {(currentWeapon player) isKindOf ["ASHPD_MK_SUS_Base_F", configFile >> "CfgWeapons"]}) then {
		[] call PG_fnc_Fizzle;
	};
}];

// Fix the PiP camera bugs
[missionnamespace, "arsenalClosed", {[] spawn PG_fnc_FixArsenalBug}] call bis_fnc_addScriptedEventhandler;
[missionnamespace, "OnGameInterrupt", {[] spawn PG_fnc_FixArsenalBug}] call bis_fnc_addScriptedEventhandler;
["ace_arsenal_displayClosed", {[] spawn PG_fnc_FixArsenalBug}] call CBA_fnc_addEventHandler;