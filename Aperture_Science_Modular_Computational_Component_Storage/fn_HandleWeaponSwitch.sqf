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

/// Description: Handles the primary weapon switching.
/// Parameters:
///		PARAMETER		|		EXPECTED INPUT TYPE		|		DESCRIPTION
///
///		isPrimary		|		Bool					|		Whether the primary weapon is being switched to.
///
///	Return value: None.

#ifdef ASHPD_DEBUG
ASHPD_LOG_FUNC("HandleWeaponSwitch");
#endif

params["_unit", ["_currentWeapon", ""]];

// Unset swap flag and return if swap flag set, prevents looping with ASHPD_fnc_SwapPortals
if (player getVariable ["ASHPD_VAR_swapFlag", false]) exitWith {
	player setVariable ["ASHPD_VAR_swapFlag", false];
};

// Player switched to portal gun
if (_currentWeapon != "" && {_currentWeapon == primaryWeapon player && {_currentWeapon isKindOf ["ASHPD_MK_SUS_Base_F", configFile >> "CfgWeapons"]}}) then {
	// Only set up crosshair and other things if not already initialized
	if (ASHPD_VAR_CROSSHAIR_HANDLE isEqualTo scriptNull) then {
		// Start drawing crosshair
		ASHPD_VAR_CROSSHAIR_HANDLE = addMissionEventHandler ["draw3D", ASHPD_fnc_DrawCrosshair];
		// Play delayed sound
		if !(player getVariable ["ASHPD_VAR_equipHandle", scriptNull] isEqualTo scriptNull) then {
			terminate (player getVariable "ASHPD_VAR_equipHandle");
		};
		player setVariable ["ASHPD_VAR_equipHandle", [] spawn {
			if !(gestureState player isEqualTo "amovpercmstpsraswpstdnon_amovpercmstpsraswrfldnon_end") then {
				waitUntil {gestureState player isEqualTo "amovpercmstpsraswpstdnon_amovpercmstpsraswrfldnon_end"};
			};
			waitUntil {!(gestureState player isEqualTo "amovpercmstpsraswpstdnon_amovpercmstpsraswrfldnon_end")};
			[player, "gun_activate"] call ASHPD_fnc_PlaySound;
			// Swap portals if current portal != current weapon mode
			if (ASHPD_VAR_CURRENT_PORTAL != currentWeaponMode player) then {
				[] call ASHPD_fnc_SwapPortals;
			};
		}];
	};
	
// Player switched to different weapon
} else {
	// Stop drawing the custom crosshair
	if !(ASHPD_VAR_CROSSHAIR_HANDLE isEqualTo scriptNull) then {
		removeMissionEventHandler ["draw3D", ASHPD_VAR_CROSSHAIR_HANDLE];
		ASHPD_VAR_CROSSHAIR_HANDLE = scriptNull;
	};
	// Let go of any grabbed items
	if (ASHPD_VAR_GRABBING) then {
		call ASHPD_fnc_ToggleGrab;
	};
};