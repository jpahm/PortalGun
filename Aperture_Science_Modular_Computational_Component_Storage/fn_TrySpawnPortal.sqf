// Copyright 2021 Sysroot/Eisenhorn

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

/// Description: Tries to spawn a portal on a surface in the direction of the player's weapon.
/// Parameters:
///		PARAMETER		|		EXPECTED INPUT TYPE		|		DESCRIPTION
///
///		portalObj		|		Object					|		The portal to be spawned.
///
///	Return value: Boolean, whether portal was successfully spawned or not.

params["_portalObj"];

private _playerPos = eyePos player;
private _castVector = (player weaponDirection currentWeapon player) vectorMultiply PG_VAR_MAX_RANGE;

// Do a raycast from the player's weapon in the direction of the weapon, out to the max range
private _rayCast = lineIntersectsSurfaces [_playerPos, _playerPos vectorAdd _castVector, player, _portalObj, true, 1, "GEOM", "VIEW"];

 // No surface detected, spawn failed
if (count _rayCast == 0) exitWith {false};
// Else, get the first surface intersected
_rayCast = _rayCast#0;

// Putting a portal here will overlap another portal, exit
if (_rayCast#2 isKindOf "Portal" && {!(_rayCast#2 isEqualTo PG_VAR_CURRENT_PORTAL)}) exitWith {false}; 

// Store current portal "surfaces" (objects the portals are on) for object detection filtering
if (PG_VAR_CURRENT_PORTAL isEqualTo PG_VAR_BLUE_PORTAL) then {
	PG_VAR_PORTAL_SURFACES set [0, _rayCast#2];
} else {
	PG_VAR_PORTAL_SURFACES set [1, _rayCast#2];
};

private _surfNormal = _rayCast#1;
// Compute the desired up vector for the portal from the surface's normal vector
private _surfVectorUp = [_surfNormal] call PG_fnc_GetSurfaceUpVec;

// Make sure the portal can fit in the desired area
if ([_portalObj, _surfVectorUp, _rayCast] call PG_fnc_DoBoundsCheck) then {
	// Move the portal to the raycast intersection position
	_portalObj setPosWorld _rayCast#0;
	detach _portalObj;
	// If portal hits vehicle, attach it so that it follows the vehicle
	if (_rayCast#2 isKindOf "AllVehicles") then {
		_portalObj attachTo [_rayCast#2];
		// If cams not yet following, add stacked event for PG_fnc_DoCamFollow
		if (!PG_VAR_CAM_FOLLOW) then {
			["PG_CF_ID", "onEachFrame", {[PG_VAR_BLUE_PORTAL, PG_VAR_ORANGE_PORTAL] remoteExecCall ["PG_fnc_DoCamFollow"]}] call BIS_fnc_addStackedEventHandler;
			PG_VAR_CAM_FOLLOW = true;
		};
	} else { // If portal doesn't hit vehicle, check if PG_fnc_DoCamFollow handler needs to be detached
		if (PG_VAR_CAM_FOLLOW && {isNull attachedTo PG_VAR_OTHER_PORTAL}) then {
			["PG_CF_ID", "onEachFrame"] call BIS_fnc_removeStackedEventHandler;
			PG_VAR_CAM_FOLLOW = false;
		};
	};
	// Orient portal opposite of the surface normal, vectorUp derived from PG_fnc_GetSurfaceUpVec
	_portalObj setVectorDirAndUp [_surfNormal vectorMultiply -1, _surfVectorUp];
	// Animate portal opening
	[_portalObj, PG_VAR_BLUE_PORTAL, PG_VAR_ORANGE_PORTAL] remoteExecCall ["PG_fnc_AnimatePortal"];
	// Spawn succeeded, return true
	true;
} else { // Else, spawn failed, return false
	[_rayCast#2, "portal_invalid_surface"] remoteExec ["PG_fnc_PlaySound"];
	[player, "gun_invalid_surface"] remoteExecCall ["say3D"];
	false;
};