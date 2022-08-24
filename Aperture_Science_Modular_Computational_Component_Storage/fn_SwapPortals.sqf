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

/// Description: Handles swapping which portal is active when firemode is changed.
/// Parameters: None.
///	Return value: None.

#ifdef ASHPD_DEBUG
ASHPD_LOG_FUNC("SwapPortals");
#endif

private _weapon = currentWeapon player;

// Only allow portal swap with portal gun equipped
if !(_weapon isKindOf ["ASHPD_MK_SUS_Base_F", configFile >> "CfgWeapons"]) exitWith {};

private _temp = ASHPD_VAR_CURRENT_PORTAL;
ASHPD_VAR_CURRENT_PORTAL = ASHPD_VAR_OTHER_PORTAL;
ASHPD_VAR_OTHER_PORTAL = _temp;

private _weaponSwapHandle = player getVariable ["ASHPD_VAR_weaponSwapHandle", scriptNull];
if !(_weaponSwapHandle isEqualTo scriptNull) then {
	terminate _weaponSwapHandle;
};

// Force weapon mode to match current portal
player setVariable ["ASHPD_VAR_weaponSwapHandle", [_weapon] spawn {
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
}];