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
ASHPD_LOG_FUNC("PostInit");
#endif

// Set update interval based on whether playing on dedicated server or not
ASHPD_VAR_UPDATE_INTERVAL = [1/ASHPD_SP_UPDATE_RATE, 1/ASHPD_MP_UPDATE_RATE] select ASHPD_VAR_IS_DEDI;

// Don't run any of the rest of this code on a dedicated server, exit here
if (isDedicated) exitWith {};

// Check whether portals already exist for this player (placed via Zeus, 3den, or createVehicle/createVehicleLocal) create them if not
if (isNil "ASHPD_VAR_BLUE_PORTAL") then {
	ASHPD_VAR_BLUE_PORTAL = createVehicle ["Portal", [0,0,0], [], 0, "CAN_COLLIDE"];
	ASHPD_VAR_BLUE_PORTAL setVariable ["open", false];
} else {
	[ASHPD_VAR_BLUE_PORTAL, true] call ASHPD_fnc_SetPortalOpen;
};
if (isNil "ASHPD_VAR_ORANGE_PORTAL") then {
	ASHPD_VAR_ORANGE_PORTAL = createVehicle ["Portal", [0,0,0], [], 0, "CAN_COLLIDE"];
	ASHPD_VAR_ORANGE_PORTAL setVariable ["open", false];
} else {
	[ASHPD_VAR_ORANGE_PORTAL, true] call ASHPD_fnc_SetPortalOpen;
};

// Create the sound sources for the portal ambiance
ASHPD_VAR_BLUE_PORTAL setVariable ["soundSource", createSoundSource ["PortalAmbientSource", ASHPD_VAR_BLUE_PORTAL, [], 0], true];
ASHPD_VAR_ORANGE_PORTAL setVariable ["soundSource", createSoundSource ["PortalAmbientSource", ASHPD_VAR_ORANGE_PORTAL, [], 0], true];

// Set the inner portals to the default noise texture and material
ASHPD_VAR_BLUE_PORTAL setObjectTextureGlobal [1, ASHPD_BLUE_NOISE_TEX];
ASHPD_VAR_ORANGE_PORTAL setObjectTextureGlobal [1, ASHPD_ORANGE_NOISE_TEX]; 
ASHPD_VAR_BLUE_PORTAL setObjectMaterialGlobal [1, ASHPD_BLUE_NOISE_MAT];
ASHPD_VAR_ORANGE_PORTAL setObjectMaterialGlobal [1, ASHPD_ORANGE_NOISE_MAT];

// Set the portal edges to the proper edge textures and materials
ASHPD_VAR_BLUE_PORTAL setObjectTextureGlobal [0, ASHPD_BLUE_EDGE_TEX]; 
ASHPD_VAR_ORANGE_PORTAL setObjectTextureGlobal [0, ASHPD_ORANGE_EDGE_TEX];
ASHPD_VAR_BLUE_PORTAL setObjectMaterialGlobal [0, ASHPD_BLUE_EDGE_MAT];
ASHPD_VAR_ORANGE_PORTAL setObjectMaterialGlobal [0, ASHPD_ORANGE_EDGE_MAT]; 

// Animate the edges and noise textures
ASHPD_VAR_BLUE_PORTAL animateSource ["Portal_Flames_Source", 100000, 1];
ASHPD_VAR_ORANGE_PORTAL animateSource ["Portal_Flames_Source", 100000, 1];
ASHPD_VAR_BLUE_PORTAL animateSource ["Portal_Noise_Source", 100000, 1];
ASHPD_VAR_ORANGE_PORTAL animateSource ["Portal_Noise_Source", 100000, 1];

// Init the portal gun mode with addonOptions settings if they're not already set
if (isNil "ASHPD_VAR_INIT_SETTINGS") then {
	ASHPD_VAR_PORTAL_GUN_MODE call ASHPD_fnc_InitGun;
};

// Update any existing portals
[] call ASHPD_fnc_UpdatePortals;
// Set up all of the event handlers
[] call ASHPD_fnc_InitEvents;