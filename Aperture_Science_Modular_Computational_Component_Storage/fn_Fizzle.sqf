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

/// Description: "Fizzles" a portal, removing and disabling it.
/// Parameters:
///		PARAMETER		|		EXPECTED INPUT TYPE		|		DESCRIPTION
///
///		Portals			|		Array of Portal objects	|		The portal(s) to be fizzled. Defaults to the player's primary and secondary portals.
///
///	Return value: None.

params[["_portals", [PG_VAR_CURRENT_PORTAL, PG_VAR_OTHER_PORTAL], [[]]]];

[player, "gun_fizzle"] remoteExecCall ["say3D"];

{
	[_x, "portal_fizzle", false] remoteExec ["PG_fnc_PlaySound"];
	// Animate portal closing
	[_portalObj, false] call PG_fnc_AnimatePortal;
	detach _x;
	_x hideObjectGlobal true;
	
	if (_x isEqualTo PG_VAR_BLUE_PORTAL) then {
		PG_VAR_BLUE_SS setPosWorld [0,0,0];
		PG_VAR_BLUE_SPAWNED = false;
	} else {
		PG_VAR_ORANGE_SS setPosWorld [0,0,0];
		PG_VAR_ORANGE_SPAWNED = false;
	};
	false;
} count _portals; 

// Update other systems with new portal info
call PG_fnc_UpdatePortals;