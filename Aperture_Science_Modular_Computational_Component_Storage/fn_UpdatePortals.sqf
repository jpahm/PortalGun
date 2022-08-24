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

/// Description: Handles updating whether the portals are activated and linked or not.
/// Parameters: None.
///	Return value: None.

#ifdef ASHPD_DEBUG
ASHPD_LOG_FUNC("UpdatePortals");
#endif

if (!ASHPD_VAR_BLUE_OPEN || {!ASHPD_VAR_ORANGE_OPEN}) then {
	// Unlink the portals if they're linked but either is no longer spawned
	if (ASHPD_VAR_PORTALS_LINKED) then {
		// Unlink the portals on all clients
		[ASHPD_VAR_BLUE_PORTAL, ASHPD_VAR_ORANGE_PORTAL] remoteExecCall ["ASHPD_fnc_UnlinkPortals", [0, -2] select ASHPD_VAR_IS_DEDI, format ["ASHPD_LINK_%1", clientOwner]];
		// Stop teleporting
		terminate ASHPD_VAR_TP_HANDLE;
		// Stop sending remote updates
		["DistributedClient"] remoteExecCall ["ASHPD_fnc_StopRemoteUpdate", [0, -2] select ASHPD_VAR_IS_DEDI, format ["ASHPD_DIST_%1", clientOwner]];
		// Stop camera following (if it's running)
		["CamFollow"] remoteExecCall ["ASHPD_fnc_StopRemoteUpdate", [0, -2] select ASHPD_VAR_IS_DEDI, format ["ASHPD_CF_%1", clientOwner]];
		// Mark cam follow as off
		ASHPD_VAR_CAM_FOLLOW = false;
		// Set linked state to false
		ASHPD_VAR_PORTALS_LINKED = false;
	};
} else {
	// Link the portals if they're unlinked but both are spawned
	if (!ASHPD_VAR_PORTALS_LINKED) then {
		// Link the portals on all clients
		[ASHPD_VAR_BLUE_PORTAL, ASHPD_VAR_ORANGE_PORTAL] remoteExecCall ["ASHPD_fnc_LinkPortals", [0, -2] select ASHPD_VAR_IS_DEDI, format ["ASHPD_LINK_%1", clientOwner]];
		// Handle teleporting on local client
		ASHPD_VAR_TP_HANDLE = [] spawn {
			while {true} do {
				[ASHPD_VAR_BLUE_PORTAL, ASHPD_VAR_ORANGE_PORTAL] call ASHPD_fnc_Teleport;
				uiSleep ASHPD_VAR_UPDATE_INTERVAL;
			};
		};
		// Delegate camera illusion and nudging to clients
		[
			[ASHPD_VAR_BLUE_PORTAL, ASHPD_VAR_ORANGE_PORTAL],
			{
				_this call ASHPD_fnc_CamIllusion;
				_this call ASHPD_fnc_Nudge;
			},
			"DistributedClient"
		] remoteExecCall ["ASHPD_fnc_StartRemoteUpdate", [0, -2] select ASHPD_VAR_IS_DEDI, format ["ASHPD_DIST_%1", clientOwner]];
		// Set linked state to true
		ASHPD_VAR_PORTALS_LINKED = true;
	};
};

// Update the camera positions on all clients
[ASHPD_VAR_BLUE_PORTAL, ASHPD_VAR_ORANGE_PORTAL] remoteExecCall ["ASHPD_fnc_UpdateCams", [0, -2] select ASHPD_VAR_IS_DEDI, format ["ASHPD_UPCAM_%1", clientOwner]];

// Update custom crosshair w/ new portal info
[] call ASHPD_fnc_UpdateCrosshair;