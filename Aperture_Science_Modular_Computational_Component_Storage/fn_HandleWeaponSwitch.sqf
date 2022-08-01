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

#ifdef PG_DEBUG
PG_LOG_FUNC("HandleWeaponSwitch");
#endif

params["_unit", ["_currentWeapon", ""]];

// Player switched to portal gun
if (_currentWeapon != "" && {_currentWeapon == primaryWeapon player && {_currentWeapon isKindOf ["ASHPD_MK_SUS_Base_F", configFile >> "CfgWeapons"]}}) then {
	// Only set up crosshair and other things if not already initialized
	if (PG_VAR_CROSSHAIR_HANDLE isEqualTo scriptNull) then {
		// Start drawing crosshair
		PG_VAR_CROSSHAIR_HANDLE = addMissionEventHandler ["draw3D", PG_fnc_DrawCrosshair];
		// Play delayed sound
		if !(PG_VAR_EQUIP_HANDLE isEqualTo scriptNull) then {
			terminate PG_VAR_EQUIP_HANDLE;
		};
		PG_VAR_EQUIP_HANDLE = [] spawn {
			waitUntil {gestureState player isEqualTo "amovpercmstpsraswpstdnon_amovpercmstpsraswrfldnon_end"};
			waitUntil {!(gestureState player isEqualTo "amovpercmstpsraswpstdnon_amovpercmstpsraswrfldnon_end")};
			[player, "gun_activate"] remoteExecCall ["say3D"];
			// Swap portals if current portal != current weapon mode
			if (PG_VAR_CURRENT_PORTAL != currentWeaponMode player) then {
				[] call PG_fnc_SwapPortals;
			};
		};
	};
	
// Player switched to different weapon
} else {
	// Stop drawing the custom crosshair
	if !(PG_VAR_CROSSHAIR_HANDLE isEqualTo scriptNull) then {
		removeMissionEventHandler ["draw3D", PG_VAR_CROSSHAIR_HANDLE];
		PG_VAR_CROSSHAIR_HANDLE = scriptNull;
	};
	// Let go of any grabbed items
	if (PG_VAR_GRABBING) then {
		call PG_fnc_ToggleGrab;
	};
};