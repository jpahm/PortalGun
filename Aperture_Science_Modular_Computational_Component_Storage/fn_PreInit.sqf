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
PG_LOG_FUNC("PreInit");
#endif

// Verify core file exists
if !(fileExists CAKE_JPG) exitWith {};

// Set up disconnect EH if server
if (isServer) then {
	PG_VAR_IS_DEDI = isDedicated;
	publicVariable "PG_VAR_IS_DEDI";
	[] call PG_fnc_InitDisconnect;
};

// Globals (you shouldn't touch these unless you know what you're doing!)
PG_VAR_PORTALS_LINKED = false;
PG_VAR_CAM_FOLLOW = false;
PG_VAR_TP_CACHE = [];
PG_VAR_TP_HANDLE = scriptNull;
PG_VAR_EQUIP_HANDLE = scriptNull;
PG_VAR_SWAP_HANDLE = scriptNull;
PG_VAR_CROSSHAIR_HANDLE = scriptNull;
PG_VAR_CROSSHAIR_IMAGE = "EmptyCursor";
PG_VAR_GRABBING = false;
PG_VAR_GRABBED_OBJECT = objNull;
PG_VAR_PROJECTILE_TYPES = PG_VAR_PROJECTILE_TYPES_SETTING splitString ", ";
PG_VAR_GRAB_SS = objNull;
PG_VAR_GRAB_HANDLE = scriptNull;
PG_VAR_GRAB_PARTICLES = objNull;
PG_VAR_POTATO_SPEAKING = false;
PG_VAR_PORTAL_SURFACES = [objNull, objNull];
PG_VAR_BH_EH_DISTANCE = 150;