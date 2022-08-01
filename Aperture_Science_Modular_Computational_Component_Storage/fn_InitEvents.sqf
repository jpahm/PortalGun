// Copyright 2021/2022 Sysroot/Eisenhorn

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

/// Description: Inits various event handlers.
/// Parameters: None.
///	Return value: None.

#ifdef PG_DEBUG
PG_LOG_FUNC("InitEvents");
#endif

// Handle shooting the portal gun, and creating/updating the portals accordingly
player addEventHandler ["Fired", {
	if ((_this#1) isKindOf ["ASHPD_MK_SUS_Base_F", configFile >> "CfgWeapons"]) then {
	
		// Keep ammo stocked if infinite ammo is enabled (only works if there's already a magazine present)
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
			if (PG_VAR_CURRENT_PORTAL == "Blue") then {
				[PG_VAR_BLUE_PORTAL, "portal_open_blue"] remoteExec ["PG_fnc_PlaySound"];
				PG_VAR_BLUE_SS setPosWorld (getPosWorld PG_VAR_BLUE_PORTAL);
				PG_VAR_BLUE_SPAWNED = true;
			} else {
				[PG_VAR_ORANGE_PORTAL, "portal_open_red"] remoteExec ["PG_fnc_PlaySound"];
				PG_VAR_ORANGE_SS setPosWorld (getPosWorld PG_VAR_ORANGE_PORTAL);
				PG_VAR_ORANGE_SPAWNED = true;
			};
			[] call PG_fnc_UpdatePortals;
		};
	};
}];

// Handle player respawn
player addMPEventHandler ["MPRespawn", {
	[] spawn PG_fnc_FixArsenalBug;
}];

// Handle player being killed
player addMPEventHandler ["MPKilled", {
	params ["_unit"];
	if (player isEqualTo _unit && PG_VAR_FIZZLE_ON_DEATH_ENABLED) then {
		[] spawn PG_fnc_Fizzle;
	};
}];

// For playing reactive potatOS dialog
player addEventHandler ["Hit", {
	params ["_unit", "_source", "_damage", "_instigator"];
	
	// Only play dialog if potatOS not disabled, not already speaking, and equipped
	if (
		!PG_VAR_POTATO_ENABLED || 
		{
			PG_VAR_POTATO_SPEAKING || 
			{!((currentWeapon player) isEqualTo "ASHPD_MK_SUS_P")}
		}
	) exitWith {};
	
	private _possibleLines = [objNull, 1];
	
	_possibleLines append [
		["potatos_not_good", "This is NOT good.", 0.05], 0.1,
		["potatos_trouble", "I think we're in trouble."], 0.1
	];
	if (_instigator isEqualTo objNull || {_instigator isEqualTo player}) then { // Reactions if they hurt themselves
		_possibleLines append [
			["potatos_brain_damage", "You really do have brain damage, don't you?", 0.01, [[" ", 0.2], [",", 0.1], ["?", 0.8]]], 0.1,
			["potatos_slow_clap", "clap,.clap,.clap"], 0.1,
			["potatos_still_working", "clap,.clap,, good, that's still working.", 0.02, [[" ", 0.2], [",", 0.275], [".", 0.8]]], 0.1,
			["potatos_wow", "Wow."], 0.1,
			["potatos_hey_moron", "Hey, moron.", 0.05], 0.1,
			["potatos_laugh", "Heh heh heh heh heh heh heh"], 0.1
		];
	} else { // Reactions if something hurt them
		_possibleLines append [
			["potatos_burn_house", "BURN HIS HOUSE DOWN!"], 0.1,
			["potatos_yell", "Argh!"], 0.1,
			["potatos_uh_oh", "Uh oh."], 0.1,
			["potatos_odds", "I'm not going to lie to you, the odds are a million to one, and that's with some generous rounding.", 0.005, [[" ", 0.2], [",", 0.15], [".", 0.8]]], 0.1,
			["potatos_about_to_kill", "I get the impression he's about to kill us.", 0.01], 0.1
		];
	};
	
	// Pick and play a random line from the pool, or don't play anything if objNull is picked
	private _randomLine = selectRandomWeighted _possibleLines;
	if !(_randomLine isEqualTo objNull) then {
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
		if !(_randomLine isEqualTo objNull) then {
			_randomLine spawn PG_fnc_SpeakPotato;
		};
		// Wait anywhere from 5 to 10 minutes before trying again
		sleep (random [300, 450, 600]);
	};
};

// Limit to one black hole per server per 10 minutes
if (isNil "PG_VAR_LAST_BH_TIME") then {
	PG_VAR_LAST_BH_TIME = -600;
};
// Check the player bringing the portal gun into water
[] spawn {
	while {true} do {
		if (PG_VAR_BH_ENABLED) then {
			private _serverTime = [] call PG_fnc_GetServerTime;
			private _position = getPosASL player;
			// Player is considered "submerged" if they are at least 1.4m below water
			private _submerged = (surfaceIsWater _position && {(_position#2) <= -1.4});
			// Trigger the black hole if we're submerged, enough time has passed since the last black hole, and we have the portal gun equipped
			if (_submerged && {_serverTime - PG_VAR_LAST_BH_TIME >= 600}) then {
				if ((currentWeapon player) isKindOf ["ASHPD_MK_SUS_Base_F", configFile >> "CfgWeapons"]) then {
					// Portal gun equipped and the player is submerged, trigger the black hole above the player
					[_position vectorAdd [0,0,300]] call PG_fnc_BlackHole;
					// Set the last BH time to serverTime
					PG_VAR_LAST_BH_TIME = _serverTime;
					// Sync last BH time to all clients
					publicVariable "PG_VAR_LAST_BH_TIME";
				};
			};
		};
		sleep 1;
	};
};

PG_VAR_SWAP_HANDLE = ["weaponMode", PG_fnc_SwapPortals] call CBA_fnc_addPlayerEventHandler;
["weapon", PG_fnc_HandleWeaponSwitch, true] call CBA_fnc_addPlayerEventHandler;

// Fix the PiP camera bugs
[missionnamespace, "arsenalClosed", {[] spawn PG_fnc_FixArsenalBug}] call bis_fnc_addScriptedEventhandler;
[missionnamespace, "OnGameInterrupt", {[] spawn PG_fnc_FixArsenalBug}] call bis_fnc_addScriptedEventhandler;
["ace_arsenal_displayClosed", {[] spawn PG_fnc_FixArsenalBug}] call CBA_fnc_addEventHandler;