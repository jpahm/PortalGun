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

// Verify core file exists
if (!(fileExists CAKE_JPG)) exitWith {};

// Set up disconnect EH if server
if (isServer) then {
	call PG_fnc_InitDisconnect;
};

// Don't run any of the rest of this code on a dedicated server, exit here
if (isDedicated) exitWith {};

// Globals (you shouldn't touch these unless you know what you're doing!)
PG_VAR_PORTAL_HEIGHT = 2; // 1.75
PG_VAR_PORTAL_WIDTH = 1.2; // 1
PG_VAR_PORTALS_LINKED = false;
PG_VAR_CAM_FOLLOW = false;
PG_VAR_ANIM_HANDLE = objNull;
PG_VAR_TP_CACHE = [];
PG_VAR_CROSSHAIR_HANDLE = objNull;
PG_VAR_CROSSHAIR_IMAGE = "EmptyCursor";
PG_VAR_GRABBING = false;
PG_VAR_GRABBED_OBJECT = objNull;
PG_VAR_PROJECTILE_TYPES = PG_VAR_PROJECTILE_TYPES_SETTING splitString ", ";
PG_VAR_GRAB_SS = objNull;
PG_VAR_GRAB_HANDLE = objNull;
PG_VAR_GRAB_PARTICLES = objNull;
PG_VAR_POTATO_SPEAKING = false;
PG_VAR_PORTAL_SURFACES = [objNull, objNull];
PG_VAR_BH_EH_DISTANCE = 150;
//PG_VAR_LAST_UPDATE_TIME = 0;
//PG_VAR_UPDATE_INTERVAL = 0.1;

// Check whether portals already exist for this player (placed via Zeus, 3den, or createVehicle/createVehicleLocal) create them if not
if (isNil "PG_VAR_BLUE_PORTAL") then {
	PG_VAR_BLUE_PORTAL = "Portal" createVehicle [0,0,0];
	PG_VAR_BLUE_SPAWNED = false;
} else {
	PG_VAR_BLUE_SPAWNED = true;
};
if (isNil "PG_VAR_ORANGE_PORTAL") then {
	PG_VAR_ORANGE_PORTAL = "Portal" createVehicle [0,0,0];
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
	PG_VAR_PORTAL_GUN_MODE call PG_fnc_InitPortals;
};
[] call PG_fnc_UpdatePortals;
[] call PG_fnc_HandleWeaponSwitch;

// Set up all of the event handlers
[] call PG_fnc_InitEvents;