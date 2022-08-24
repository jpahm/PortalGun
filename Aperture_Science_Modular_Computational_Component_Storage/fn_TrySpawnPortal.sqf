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

#ifdef ASHPD_DEBUG
ASHPD_LOG_FUNC("TrySpawnPortal");
#endif

params["_portal"];

private _portalObj = objNull; 

if (_portal == "Blue") then {
	_portalObj = ASHPD_VAR_BLUE_PORTAL;
} else {
	_portalObj = ASHPD_VAR_ORANGE_PORTAL;
};

private _eyePos = eyePos player;
private _castVector = (player weaponDirection currentWeapon player) vectorMultiply ASHPD_VAR_MAX_RANGE;

// Do a raycast from the player's weapon in the direction of the weapon, out to the max range
private _rayCast = lineIntersectsSurfaces [_eyePos, _eyePos vectorAdd _castVector, player, _portalObj, true, 1, "GEOM", "FIRE"];

 // No surface detected, spawn failed
if (count _rayCast == 0) exitWith {false};
// Else, get the first surface intersected
_rayCast = _rayCast#0;

// Putting a portal here will overlap another portal, exit
if (_rayCast#2 isKindOf "Portal" && {!(_rayCast#2 isEqualTo _portalObj)}) exitWith {false}; 

// Vector normal to the surface casted onto
private _surfNormal = _rayCast#1;
// Compute the desired up vector for the portal from the surface's normal vector
private _surfVectorUp = [_surfNormal] call ASHPD_fnc_GetSurfaceUpVec;

// Make sure the portal can fit in the desired area
if ([_portalObj, _surfVectorUp, _rayCast] call ASHPD_fnc_BoundsCheck) then {

	// Detach anything attached to the portal
	detach _portalObj;
	// Clear the teleport cache since we have a fresh portal
	ASHPD_VAR_TP_CACHE = [];
	
	// Add new portal "surface" (object the portal is on) for object detection filtering
	if (_portalObj isEqualTo ASHPD_VAR_BLUE_PORTAL) then {
		ASHPD_VAR_PORTAL_SURFACES pushBack (ASHPD_VAR_PORTAL_SURFACES#0);
		ASHPD_VAR_PORTAL_SURFACES set [0, _rayCast#2];
	} else {
		ASHPD_VAR_PORTAL_SURFACES pushBack (ASHPD_VAR_PORTAL_SURFACES#1);
		ASHPD_VAR_PORTAL_SURFACES set [1, _rayCast#2];
	};
	
	// Move the portal to the raycast intersection position
	_portalObj setPosWorld (_rayCast#0);
	
	// Remove old portal "surface" now that portal has moved
	ASHPD_VAR_PORTAL_SURFACES resize 2;
	
	// Unhide the portal if it's been hidden (i.e. via fizzling)
	if (isObjectHidden _portalObj) then {
		ASHPD_HIDE_SERVER(_portalObj, false);
	};
	
	// If portal hits vehicle, attach it so that it follows the vehicle
	if (_rayCast#2 isKindOf "AllVehicles") then {
		_portalObj attachTo [_rayCast#2];
		// If cams not yet following, add remote update for ASHPD_fnc_CamFollow
		if (!ASHPD_VAR_CAM_FOLLOW) then {
			[
				[ASHPD_VAR_BLUE_PORTAL, ASHPD_VAR_ORANGE_PORTAL],
				{
					_this call ASHPD_fnc_CamFollow;
				},
				"CamFollow"
			] remoteExecCall ["ASHPD_fnc_StartRemoteUpdate", [0, -2] select ASHPD_VAR_IS_DEDI, format ["ASHPD_CF_%1", clientOwner]];
			ASHPD_VAR_CAM_FOLLOW = true;
		};
	} else { // If portal doesn't hit vehicle, check if ASHPD_fnc_CamFollow remote update needs to be stopped
		if (ASHPD_VAR_CAM_FOLLOW && {isNull attachedTo ([ASHPD_VAR_BLUE_PORTAL, ASHPD_VAR_ORANGE_PORTAL] select (ASHPD_VAR_OTHER_PORTAL == "Orange"))}) then {
			["CamFollow"] remoteExecCall ["ASHPD_fnc_StopRemoteUpdate", [0, -2] select ASHPD_VAR_IS_DEDI, format ["ASHPD_CF_%1", clientOwner]];
			ASHPD_VAR_CAM_FOLLOW = false;
		};
	};
	
	// Orient portal opposite of the surface normal, vectorUp derived from ASHPD_fnc_GetSurfaceUpVec
	_portalObj setVectorDirAndUp [_surfNormal vectorMultiply -1, _surfVectorUp];
	
	// Animate portal opening
	[_portalObj, true] call ASHPD_fnc_SetPortalOpen;
	
	// Spawn succeeded, return true
	true;
	
} else { // If the bound check fails

	// Play the invalid surface SFX at the cast location
	[_rayCast#2, "portal_invalid_surface"] call ASHPD_fnc_PlaySound;
	
	// Play the gun's invalid surface SFX at the player's location
	[player, "gun_invalid_surface"] call ASHPD_fnc_PlaySound;
	
	// Spawn failed, return false
	false;
};