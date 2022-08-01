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

#ifdef PG_DEBUG
PG_LOG_FUNC("PostInit");
#endif

// Set update interval based on whether playing on dedicated server or not
PG_VAR_UPDATE_INTERVAL = [1/144, 1/60] select PG_VAR_IS_DEDI;

// Don't run any of the rest of this code on a dedicated server, exit here
if (isDedicated) exitWith {};

// Check whether portals already exist for this player (placed via Zeus, 3den, or createVehicle/createVehicleLocal) create them if not
if (isNil "PG_VAR_BLUE_PORTAL") then {
	PG_VAR_BLUE_PORTAL = createVehicle ["Portal", [0,0,0], [], 0, "CAN_COLLIDE"];
	PG_VAR_BLUE_SPAWNED = false;
} else {
	PG_VAR_BLUE_SPAWNED = true;
};
if (isNil "PG_VAR_ORANGE_PORTAL") then {
	PG_VAR_ORANGE_PORTAL = createVehicle ["Portal", [0,0,0], [], 0, "CAN_COLLIDE"];
	PG_VAR_ORANGE_SPAWNED = false;
} else {
	PG_VAR_ORANGE_SPAWNED = true;
};

// Create the sound sources for the portal ambiance
PG_VAR_BLUE_SS = createSoundSource ["PortalAmbientSource", PG_VAR_BLUE_PORTAL, [], 0];
PG_VAR_ORANGE_SS = createSoundSource ["PortalAmbientSource", PG_VAR_ORANGE_PORTAL, [], 0];

// Set the inner portals to the default noise texture and material
PG_VAR_BLUE_PORTAL setObjectTextureGlobal [1, PG_BLUE_NOISE_TEX];
PG_VAR_ORANGE_PORTAL setObjectTextureGlobal [1, PG_ORANGE_NOISE_TEX]; 
PG_VAR_BLUE_PORTAL setObjectMaterialGlobal [1, PG_BLUE_NOISE_MAT];
PG_VAR_ORANGE_PORTAL setObjectMaterialGlobal [1, PG_ORANGE_NOISE_MAT];

// Set the portal edges to the proper edge textures and materials
PG_VAR_BLUE_PORTAL setObjectTextureGlobal [0, PG_BLUE_EDGE_TEX]; 
PG_VAR_ORANGE_PORTAL setObjectTextureGlobal [0, PG_ORANGE_EDGE_TEX];
PG_VAR_BLUE_PORTAL setObjectMaterialGlobal [0, PG_BLUE_EDGE_MAT];
PG_VAR_ORANGE_PORTAL setObjectMaterialGlobal [0, PG_ORANGE_EDGE_MAT]; 

// Animate the edges and noise textures
PG_VAR_BLUE_PORTAL animateSource ["Portal_Flames_Source", 100000, 1];
PG_VAR_ORANGE_PORTAL animateSource ["Portal_Flames_Source", 100000, 1];
PG_VAR_BLUE_PORTAL animateSource ["Portal_Noise_Source", 100000, 1];
PG_VAR_ORANGE_PORTAL animateSource ["Portal_Noise_Source", 100000, 1];

// Init the portal gun mode with addonOptions settings if they're not already set
if (isNil "PG_VAR_INIT_SETTINGS") then {
	PG_VAR_PORTAL_GUN_MODE call PG_fnc_InitGun;
};
[] call PG_fnc_UpdatePortals;
[] call PG_fnc_HandleWeaponSwitch;

// Set up all of the event handlers
[] call PG_fnc_InitEvents;