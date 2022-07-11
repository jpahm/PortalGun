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

params[["_isPrimary", ((currentWeapon player) isEqualTo (primaryWeapon player)), [true]]];

// Player switched to portal gun
if (_isPrimary && {(primaryWeapon player) isKindOf ["ASHPD_MK_SUS_Base_F", configFile >> "CfgWeapons"]}) then {
	// Only set up crosshair and other things if not already initialized
	if (PG_VAR_CROSSHAIR_HANDLE isEqualTo objNull) then {
		// Start drawing crosshair
		PG_VAR_CROSSHAIR_HANDLE = addMissionEventHandler ["draw3D", PG_fnc_DrawCrosshair];
		// Play delayed sound
		[] spawn {
			sleep 1;
			[player, "gun_activate"] remoteExecCall ["say3D"];
			sleep 1;
			// Re-initialize portal gun settings
			PG_VAR_INIT_SETTINGS call PG_fnc_InitPortals;
			// Make sure our current portal still matches the firemode, swap portals if not
			if (
				(PG_VAR_CURRENT_PORTAL == PG_VAR_BLUE_PORTAL && currentWeaponMode player != "Blue") ||
				{PG_VAR_CURRENT_PORTAL == PG_VAR_ORANGE_PORTAL && currentWeaponMode player != "Orange"}
			) then {
				[] call PG_fnc_SwapPortals;
			};
		};
	};
// Player switched to different weapon
} else {
	// Stop drawing the custom crosshair
	if (!(PG_VAR_CROSSHAIR_HANDLE isEqualTo objNull)) then {
		removeMissionEventHandler ["draw3D", PG_VAR_CROSSHAIR_HANDLE];
		PG_VAR_CROSSHAIR_HANDLE = objNull;
	};
	// Let go of any grabbed items
	if (PG_VAR_GRABBING) then {
		call PG_fnc_TryGrab;
	};
};