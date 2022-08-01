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

#ifdef PG_DEBUG
PG_LOG_FUNC("UpdatePortals");
#endif

if (!PG_VAR_BLUE_SPAWNED || {!PG_VAR_ORANGE_SPAWNED}) then {
	// Unlink the portals if they're linked but either is no longer spawned
	if (PG_VAR_PORTALS_LINKED) then {
		// Unlink the portals on all clients
		[PG_VAR_BLUE_PORTAL, PG_VAR_ORANGE_PORTAL] remoteExecCall ["PG_fnc_UnlinkPortals", [0, -2] select PG_VAR_IS_DEDI, format ["PG_LINK_%1", clientOwner]];
		// Stop teleporting
		terminate PG_VAR_TP_HANDLE;
		// Stop sending remote updates
		["DistributedClient"] remoteExecCall ["PG_fnc_StopRemoteUpdate", [0, -2] select PG_VAR_IS_DEDI, format ["PG_DIST_%1", clientOwner]];
		// Stop camera following (if it's running)
		["CamFollow"] remoteExecCall ["PG_fnc_StopRemoteUpdate", [0, -2] select PG_VAR_IS_DEDI, format ["PG_CF_%1", clientOwner]];
		// Mark cam follow as off
		PG_VAR_CAM_FOLLOW = false;
		// Set linked state to false
		PG_VAR_PORTALS_LINKED = false;
	};
} else {
	// Link the portals if they're unlinked but both are spawned
	if (!PG_VAR_PORTALS_LINKED) then {
		// Link the portals on all clients
		[PG_VAR_BLUE_PORTAL, PG_VAR_ORANGE_PORTAL] remoteExecCall ["PG_fnc_LinkPortals", [0, -2] select PG_VAR_IS_DEDI, format ["PG_LINK_%1", clientOwner]];
		// Handle teleporting on local client
		PG_VAR_TP_HANDLE = [] spawn {
			while {true} do {
				[PG_VAR_BLUE_PORTAL, PG_VAR_ORANGE_PORTAL] call PG_fnc_Teleport;
				uiSleep PG_VAR_UPDATE_INTERVAL;
			};
		};
		// Delegate camera illusion and nudging to clients
		[
			[PG_VAR_BLUE_PORTAL, PG_VAR_ORANGE_PORTAL],
			{
				_this call PG_fnc_CamIllusion;
				_this call PG_fnc_Nudge;
			},
			"DistributedClient"
		] remoteExecCall ["PG_fnc_StartRemoteUpdate", [0, -2] select PG_VAR_IS_DEDI, format ["PG_DIST_%1", clientOwner]];
		// Set linked state to true
		PG_VAR_PORTALS_LINKED = true;
	};
};

// Update the camera positions on all clients
[PG_VAR_BLUE_PORTAL, PG_VAR_ORANGE_PORTAL] remoteExecCall ["PG_fnc_UpdateCams", [0, -2] select PG_VAR_IS_DEDI, format ["PG_UPCAM_%1", clientOwner]];

// Update custom crosshair w/ new portal info
[] call PG_fnc_UpdateCrosshair;