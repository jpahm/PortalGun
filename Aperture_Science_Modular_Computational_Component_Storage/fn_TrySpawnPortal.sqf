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

/// Description: Tries to spawn a portal on a surface in the direction of the player's weapon.
/// Parameters:
///		PARAMETER		|		EXPECTED INPUT TYPE		|		DESCRIPTION
///
///		portal			|		String					|		The string representing the portal to be spawned.
///
///	Return value: Boolean, whether portal was successfully spawned or not.

#ifdef PG_DEBUG
PG_LOG_FUNC("TrySpawnPortal");
#endif

params["_portal"];

private _portalObj = objNull; 

hint _portal;

if (_portal == "Blue") then {
	_portalObj = PG_VAR_BLUE_PORTAL;
} else {
	_portalObj = PG_VAR_ORANGE_PORTAL;
};

private _eyePos = eyePos player;
private _castVector = (player weaponDirection currentWeapon player) vectorMultiply PG_VAR_MAX_RANGE;

// Do a raycast from the player's weapon in the direction of the weapon, out to the max range
private _rayCast = lineIntersectsSurfaces [_eyePos, _eyePos vectorAdd _castVector, player, _portalObj, true, 1, "VIEW", "GEOM"];

 // No surface detected, spawn failed
if (count _rayCast == 0) exitWith {false};
// Else, get the first surface intersected
_rayCast = _rayCast#0;

// Putting a portal here will overlap another portal, exit
if (_rayCast#2 isKindOf "Portal" && {!(_rayCast#2 isEqualTo _portalObj)}) exitWith {false}; 

// Vector normal to the surface casted onto
private _surfNormal = _rayCast#1;
// Compute the desired up vector for the portal from the surface's normal vector
private _surfVectorUp = [_surfNormal] call PG_fnc_GetSurfaceUpVec;

// Make sure the portal can fit in the desired area
if ([_portalObj, _surfVectorUp, _rayCast] call PG_fnc_BoundsCheck) then {

	// Detach anything attached to the portal
	detach _portalObj;
	// Clear the teleport cache since we have a fresh portal
	PG_VAR_TP_CACHE = [];
	
	// Add new portal "surface" (object the portal is on) for object detection filtering
	if (_portalObj isEqualTo PG_VAR_BLUE_PORTAL) then {
		PG_VAR_PORTAL_SURFACES pushBack (PG_VAR_PORTAL_SURFACES#0);
		PG_VAR_PORTAL_SURFACES set [0, _rayCast#2];
	} else {
		PG_VAR_PORTAL_SURFACES pushBack (PG_VAR_PORTAL_SURFACES#1);
		PG_VAR_PORTAL_SURFACES set [1, _rayCast#2];
	};
	
	// Move the portal to the raycast intersection position
	_portalObj setPosWorld _rayCast#0;
	
	// Remove old portal "surface" now that portal has moved
	PG_VAR_PORTAL_SURFACES resize 2;
	
	// Unhide the portal if it's been hidden (i.e. via fizzling)
	if (isObjectHidden _portalObj) then {
		[_portalObj, false] remoteExecCall ["hideObjectGlobal", [0, 2] select PG_VAR_IS_DEDI];
	};
	
	// If portal hits vehicle, attach it so that it follows the vehicle
	if (_rayCast#2 isKindOf "AllVehicles") then {
		_portalObj attachTo [_rayCast#2];
		// If cams not yet following, add remote update for PG_fnc_CamFollow
		if (!PG_VAR_CAM_FOLLOW) then {
			[
				[PG_VAR_BLUE_PORTAL, PG_VAR_ORANGE_PORTAL],
				{
					_this call PG_fnc_CamFollow;
				},
				"CamFollow"
			] remoteExecCall ["PG_fnc_StartRemoteUpdate", [0, -2] select PG_VAR_IS_DEDI, format ["PG_CF_%1", clientOwner]];
			PG_VAR_CAM_FOLLOW = true;
		};
	} else { // If portal doesn't hit vehicle, check if PG_fnc_CamFollow remote update needs to be stopped
		if (PG_VAR_CAM_FOLLOW && {isNull attachedTo PG_VAR_OTHER_PORTAL}) then {
			["CamFollow"] remoteExecCall ["PG_fnc_StopRemoteUpdate", [0, -2] select PG_VAR_IS_DEDI, format ["PG_CF_%1", clientOwner]];
			PG_VAR_CAM_FOLLOW = false;
		};
	};
	
	// Orient portal opposite of the surface normal, vectorUp derived from PG_fnc_GetSurfaceUpVec
	_portalObj setVectorDirAndUp [_surfNormal vectorMultiply -1, _surfVectorUp];
	
	// Animate portal opening
	[_portalObj, true] call PG_fnc_AnimatePortal;
	
	// Spawn succeeded, return true
	true;
	
} else { // If the bound check fails

	// Play the invalid surface SFX at the cast location
	[_rayCast#2, "portal_invalid_surface"] remoteExec ["PG_fnc_PlaySound"];
	
	// Play the gun's invalid surface SFX at the player's location
	[player, "gun_invalid_surface"] remoteExecCall ["say3D"];
	
	// Spawn failed, return false
	false;
};