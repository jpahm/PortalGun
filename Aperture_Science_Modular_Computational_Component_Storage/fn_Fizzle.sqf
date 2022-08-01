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

/// Description: "Fizzles" a portal, removing and disabling it. Needs to run in a scheduled environment.
/// Parameters:
///		PARAMETER		|		EXPECTED INPUT TYPE		|		DESCRIPTION
///
///		Portals			|		Array of Portal objects	|		The portal(s) to be fizzled. Defaults to the player's primary and secondary portals.
///
///	Return value: None.

#ifdef PG_DEBUG
PG_LOG_FUNC("Fizzle");
#endif

params[["_portals", [PG_VAR_CURRENT_PORTAL, PG_VAR_OTHER_PORTAL], [[]]]];

[player, "gun_fizzle"] remoteExecCall ["say3D"];

private _fizzleSpawns = [];

// Fizzle each given portal individually
{
	if (_x == "Blue") then {
		_x = PG_VAR_BLUE_PORTAL;
	} else {
		_x = PG_VAR_ORANGE_PORTAL;
	};
	_fizzleSpawns pushBack (_x spawn {
		[_this, "portal_fizzle", false] remoteExec ["PG_fnc_PlaySound"];
		// Animate portal closing
		[_this, false] call PG_fnc_AnimatePortal;
		sleep 0.25;
		detach _this;
		[_this, true] remoteExecCall ["hideObjectGlobal", [0, 2] select PG_VAR_IS_DEDI];
		
		if (_this isEqualTo PG_VAR_BLUE_PORTAL) then {
			PG_VAR_BLUE_PORTAL setPosWorld [0,0,0];
			PG_VAR_BLUE_SS setPosWorld [0,0,0];
			PG_VAR_BLUE_SPAWNED = false;
		} else {
			PG_VAR_ORANGE_PORTAL setPosWorld [0,0,0];
			PG_VAR_ORANGE_SS setPosWorld [0,0,0];
			PG_VAR_ORANGE_SPAWNED = false;
		};
	});
} forEach _portals; 

// Wait for individual fizzles to complete
waitUntil { (_fizzleSpawns select { scriptDone _x }) isEqualTo _fizzleSpawns };

// Update other systems with new portal info
[] call PG_fnc_UpdatePortals;