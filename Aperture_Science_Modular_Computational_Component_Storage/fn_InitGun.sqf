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

/// Description: Sets the portal gun's available portals. One or both params need to be true.
/// Parameters:
///		PARAMETER		|		EXPECTED INPUT TYPE		|		DESCRIPTION
///
///		bPortal			|		Bool					|		Whether firing the blue portal is enabled.
///		oPortal			|		Bool					|		Whether firing the orange portal is enabled.
///
///	Return value: None.

#ifdef ASHPD_DEBUG
ASHPD_LOG_FUNC("InitGun");
#endif

params[["_bPortal", true, [true]], ["_oPortal", true, [true]]];

if (!_bPortal && {!_oPortal}) then {
	// Error, no portals given, default to dual
	ASHPD_ERROR("$STR_PGUN_EX_NoPortals");
	_bPortal = true;
	_oPortal = true;
}; 

// Save init settings for refresh purposes
ASHPD_VAR_INIT_SETTINGS = [_bPortal, _oPortal];

if (_bPortal && _oPortal) then {
	ASHPD_VAR_CURRENT_PORTAL = "Blue";
	ASHPD_VAR_OTHER_PORTAL = "Orange";
} else { // If single portal mode
	if (_bPortal && {!_oPortal}) then { // If only using blue portal
		ASHPD_VAR_CURRENT_PORTAL = "Blue";
		ASHPD_VAR_OTHER_PORTAL = "Blue";
	} else { // If only using orange portal
		ASHPD_VAR_CURRENT_PORTAL = "Orange";
		ASHPD_VAR_OTHER_PORTAL = "Orange";
	};
};

// Force weapon mode to match current portal if portal gun equipped
if (currentWeapon player isKindOf ["ASHPD_MK_SUS_Base_F", configFile >> "CfgWeapons"]) then {
	[currentWeapon player] spawn {
		params["_weapon"];
		// Temporarily remove weaponMode EH so we can swap the mode without looping
		["weaponMode", ASHPD_VAR_SWAP_EH_ID] call CBA_fnc_removePlayerEventHandler;
		sleep 0.1;
		// Make sure firemode matches current portal setting
		private _ammo = player ammo _weapon;
		player setAmmo [_weapon, 0];
		player forceWeaponFire [_weapon, ASHPD_VAR_CURRENT_PORTAL];
		player setAmmo [_weapon, _ammo];
		sleep 0.1;
		// Restore weaponMode EH
		ASHPD_VAR_SWAP_EH_ID = ["weaponMode", ASHPD_fnc_SwapPortals] call CBA_fnc_addPlayerEventHandler;
	};
};

// Update crosshair to match new portal gun settings
[] call ASHPD_fnc_UpdateCrosshair;