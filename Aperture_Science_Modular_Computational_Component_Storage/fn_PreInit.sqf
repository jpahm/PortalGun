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

/// Description: Inits the mod.
/// Parameters: None.
///	Return value: None.

#ifdef ASHPD_DEBUG
ASHPD_LOG_FUNC("PreInit");
#endif

// Verify core file exists
if !(fileExists CAKE_JPG) exitWith {};

// Set up disconnect EH if server
if (isServer) then {
	ASHPD_VAR_IS_DEDI = isDedicated;
	publicVariable "ASHPD_VAR_IS_DEDI";
	[] call ASHPD_fnc_InitDisconnect;
};

// Globals (you shouldn't touch these unless you know what you're doing!)

ASHPD_VAR_PORTALS_LINKED = false; // Whether the player's portals are "linked" (teleporting, camera illusion, etc. are enabled).
ASHPD_VAR_CAM_FOLLOW = false; // Whether the player's portal cameras are set to follow the portals in real-time (used for vehicle-attached portals).
ASHPD_VAR_TP_CACHE = []; // Cache used for preventing objects from infinitely teleporting back-and-forth between portals.
ASHPD_VAR_TP_HANDLE = scriptNull; // Handle representing the teleport script spawn, can be terminated to disable teleporting between player's portals.
ASHPD_VAR_CROSSHAIR_HANDLE = scriptNull; // Handle representing the crosshair drawing script spawn, can be terminated to disable the player's custom crosshair.
ASHPD_VAR_GRABBING = false; // Whether the player's portal gun is currently grabbing something.
ASHPD_VAR_POTATO_SPEAKING = false; // Whether the player's PotatOS (if equipped) is currently speaking.
ASHPD_VAR_PORTAL_SURFACES = [objNull, objNull]; // The objects (surfaces) that each portal (blue, orange) is currently on.