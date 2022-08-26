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

#ifdef ASHPD_DEBUG
ASHPD_LOG_FUNC("InitEvents");
#endif

// Handle shooting the portal gun, and creating/updating the portals accordingly
player addEventHandler ["Fired", {
	if ((_this#1) isKindOf ["ASHPD_MK_SUS_Base_F", configFile >> "CfgWeapons"]) then {
	
		// Keep ammo stocked if infinite ammo is enabled (only works if there's already a magazine present)
		if (ASHPD_VAR_INFINITE_AMMO_ENABLED) then {
			private _muzzle = currentMuzzle player;
			private _ammoCount = player ammo _muzzle;
			if (_ammoCount <= 1) then {
				player setAmmo [_muzzle, 3];
			} else {
				player setAmmo [_muzzle, _ammoCount + 1];
			};
		};
	
		// Only try to spawn portal if not grabbing anything
		if (!ASHPD_VAR_GRABBING && {ASHPD_VAR_CURRENT_PORTAL call ASHPD_fnc_TrySpawnPortal}) then {
			if (ASHPD_VAR_CURRENT_PORTAL == "Blue") then {
				[ASHPD_VAR_BLUE_PORTAL, "portal_open_blue"] call ASHPD_fnc_PlaySound;
				(ASHPD_VAR_BLUE_PORTAL getVariable "soundSource") setPosWorld (getPosWorld ASHPD_VAR_BLUE_PORTAL);
			} else {
				[ASHPD_VAR_ORANGE_PORTAL, "portal_open_red"] call ASHPD_fnc_PlaySound;
				(ASHPD_VAR_ORANGE_PORTAL getVariable "soundSource") setPosWorld (getPosWorld ASHPD_VAR_ORANGE_PORTAL);
			};
		};
	};
}];

// Handle player respawn
player addEventHandler ["Respawn", {
	[] spawn ASHPD_fnc_FixArsenalBug;
}];

// Handle player being killed
player addEventHandler ["Killed", {
	params ["_unit"];
	if (ASHPD_VAR_FIZZLE_ON_DEATH_ENABLED) then {
		[] spawn ASHPD_fnc_Fizzle;
	};
}];

// Add HandleDamage EH for playing reactive potatOS dialog and preventing fall damage with ASHPD_VAR_LONG_FALL_BOOTS_ENABLED
player addEventHandler ["HandleDamage", {
	
	params ["_unit", "_selection", "_damage", "_source", "_projectile", "_hitIndex", "_instigator", "_hitPoint"];
	
	// Disable fall damage if portal gun equipped and long fall boots enabled
	if (
		currentWeapon player isKindOf ["ASHPD_MK_SUS_Base_F", configFile >> "CfgWeapons"] && 
		{_source isEqualTo player && _projectile == "" && ASHPD_VAR_LONG_FALL_BOOTS_ENABLED}
	) then {
		0;
	} else {
		// Otherwise do normal damage handling
		// Only play potato dialog if potatOS not disabled, not already speaking, and equipped
		if (ASHPD_VAR_POTATO_ENABLED && {!ASHPD_VAR_POTATO_SPEAKING && {currentWeapon player isEqualTo "ASHPD_MK_SUS_P"}}) then {
			private _possibleLines = [objNull, 1];
			
			_possibleLines append [
				["potatos_not_good", "This is NOT good.", 0.05], 0.1,
				["potatos_trouble", "I think we're in trouble."], 0.1
			];
			if (_source isEqualTo player) then { // Reactions if they hurt themselves
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
				_randomLine spawn ASHPD_fnc_SpeakPotato;
			};
		};
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
			_randomLine spawn ASHPD_fnc_SpeakPotato;
		};
		// Wait anywhere from 5 to 10 minutes before trying again
		sleep (random [300, 450, 600]);
	};
};

// Check the player bringing the portal gun into water
[] spawn {
	private _serverTime = [] call ASHPD_fnc_GetServerTime;
	while {true} do {
		if (ASHPD_VAR_BH_ENABLED) then {
			private _position = getPosASL player;
			// Player is considered "submerged" if they are at least 1.4m below water
			private _submerged = (surfaceIsWater _position && {(_position#2) <= -1.4});
			// Trigger the black hole if we're submerged, enough time has passed since the last black hole, and we have the portal gun equipped
			if (_submerged && {_serverTime - ASHPD_VAR_LAST_BH_TIME >= ASHPD_BH_COOLDOWN}) then {
				if ((currentWeapon player) isKindOf ["ASHPD_MK_SUS_Base_F", configFile >> "CfgWeapons"]) then {
					// Portal gun equipped and the player is submerged, trigger the black hole above the player
					[_position vectorAdd [0,0,350]] remoteExec ["ASHPD_fnc_BlackHole", [0, 2] select ASHPD_VAR_IS_DEDI];
					// Refresh serverTime
					_serverTime = [] call ASHPD_fnc_GetServerTime;
				};
			};
		};
		sleep 1;
		_serverTime = _serverTime + 1;
	};
};

// Handle firemode swapping and weapon switching
ASHPD_VAR_SWAP_EH_ID = ["weaponMode", ASHPD_fnc_SwapPortals] call CBA_fnc_addPlayerEventHandler;
["weapon", ASHPD_fnc_HandleWeaponSwitch, true] call CBA_fnc_addPlayerEventHandler;

// Fix the PiP camera bugs
["featureCamera", {[] spawn ASHPD_fnc_FixArsenalBug}] call CBA_fnc_addPlayerEventHandler;
[missionnamespace, "OnGameInterrupt", {[] spawn ASHPD_fnc_FixArsenalBug}] call bis_fnc_addScriptedEventhandler;