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

// Don't proceed further if the portals don't exist yet (preInit)
if (isNil "ASHPD_VAR_BLUE_PORTAL" || isNil "ASHPD_VAR_ORANGE_PORTAL") exitWith {};

if (_bPortal && _oPortal) then {
	ASHPD_VAR_CURRENT_PORTAL = ASHPD_VAR_BLUE_PORTAL;
	ASHPD_VAR_OTHER_PORTAL = ASHPD_VAR_ORANGE_PORTAL;
} else { // If single portal mode
	if (_bPortal && {!_oPortal}) then { // If only using blue portal
		ASHPD_VAR_CURRENT_PORTAL = ASHPD_VAR_BLUE_PORTAL;
		ASHPD_VAR_OTHER_PORTAL = ASHPD_VAR_BLUE_PORTAL;
	} else { // If only using orange portal
		ASHPD_VAR_CURRENT_PORTAL = ASHPD_VAR_ORANGE_PORTAL;
		ASHPD_VAR_OTHER_PORTAL = ASHPD_VAR_ORANGE_PORTAL;
	};
};

// Force weapon mode to match current portal if portal gun equipped
if (currentWeapon player isKindOf ["ASHPD_MK_SUS_Base_F", configFile >> "CfgWeapons"]) then {
	// Force weapon mode to match current portal
	player setVariable ["ASHPD_VAR_modeChangeHandle", [currentWeapon player] spawn {
		params["_weapon"];
		sleep 0.1;
		// Make sure firemode matches current portal setting
		private _ammo = player ammo _weapon;
		player setAmmo [_weapon, 0];
		player forceWeaponFire [_weapon, ASHPD_FIREMODE];
		player setAmmo [_weapon, _ammo];
		sleep 0.1;
		player setVariable ["ASHPD_VAR_modeChangeHandle", scriptNull];
	}];
};

// Update crosshair to match new portal gun settings
[] call ASHPD_fnc_UpdateCrosshair;