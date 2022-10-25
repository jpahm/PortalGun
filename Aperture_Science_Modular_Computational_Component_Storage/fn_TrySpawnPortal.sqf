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
///		portal			|		Object					|		The portal to be "spawned".
///
///	Return value: Boolean, whether portal was successfully spawned or not.

#ifdef ASHPD_DEBUG
ASHPD_LOG_FUNC("TrySpawnPortal");
#endif

params["_portalObj"];

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

	// Clear the teleport cache since we have a fresh portal
	ASHPD_VAR_TP_CACHE = [];
	
	// Close original portal
	[_portalObj, false] call ASHPD_fnc_SetPortalOpen;
	
	// Create new portal object at raycast intersect position (clone of current _portalObj)
	private _newPortalObj = createVehicle ["Portal", (ASLToAGL (_rayCast#0)) vectorDiff [0, 0, 1.0784421], [], 0, "CAN_COLLIDE"];
	
	// Clone all variables from old portal to new portal
	{
		_newPortalObj setVariable [_x, _portalObj getVariable _x, true];
	} forEach (allVariables _portalObj);
	
	// Add new portal to GC
	[getPlayerUID player, [_newPortalObj]] remoteExecCall ["ASHPD_fnc_UpdateGC", ASHPD_SERVER];
	// Remove old portal from GC
	[getPlayerUID player, [_portalObj], false] remoteExecCall ["ASHPD_fnc_UpdateGC", ASHPD_SERVER];
	
	// Delete original portal object
	deleteVehicle _portalObj;
	
	// Move sound source to new portal location
	(_newPortalObj getVariable "soundSource") setPosWorld (getPosWorld _newPortalObj);
	
	// Handle portal-specific setup for new portal, add new surface to ASHPD_VAR_PORTAL_SURFACES
	if (_newPortalObj getVariable "isBlue") then {
		ASHPD_VAR_PORTAL_SURFACES pushBack (ASHPD_VAR_PORTAL_SURFACES#0);
		ASHPD_VAR_PORTAL_SURFACES set [0, _rayCast#2];
		ASHPD_VAR_BLUE_PORTAL = _newPortalObj;
	} else {
		ASHPD_VAR_PORTAL_SURFACES pushBack (ASHPD_VAR_PORTAL_SURFACES#1);
		ASHPD_VAR_PORTAL_SURFACES set [1, _rayCast#2];
		ASHPD_VAR_ORANGE_PORTAL = _newPortalObj;
	};
	
	// Update current portal to new portal object
	ASHPD_VAR_CURRENT_PORTAL = _newPortalObj;
	
	// Remove old portal "surfaces" now that new surface has been set
	ASHPD_VAR_PORTAL_SURFACES resize 2;
	
	// If portal hits vehicle, attach it so that it follows the vehicle
	if (_rayCast#2 isKindOf "AllVehicles") then {
		_newPortalObj attachTo [_rayCast#2];
		// If cams not yet following, add remote update for ASHPD_fnc_CamFollow
		if (!ASHPD_VAR_CAM_FOLLOW) then {
			[
				[ASHPD_VAR_BLUE_PORTAL, ASHPD_VAR_ORANGE_PORTAL],
				{
					_this call ASHPD_fnc_CamFollow;
				},
				"CamFollow"
			] remoteExecCall ["ASHPD_fnc_StartRemoteUpdate", ASHPD_CLIENTS, format ["ASHPD_CF_%1", clientOwner]];
			ASHPD_VAR_CAM_FOLLOW = true;
		};
	} else { // If portal doesn't hit vehicle, check if ASHPD_fnc_CamFollow remote update needs to be stopped
		if (ASHPD_VAR_CAM_FOLLOW && {isNull attachedTo ([ASHPD_VAR_BLUE_PORTAL, ASHPD_VAR_ORANGE_PORTAL] select (ASHPD_VAR_OTHER_PORTAL == "Orange"))}) then {
			["CamFollow"] remoteExecCall ["ASHPD_fnc_StopRemoteUpdate", ASHPD_CLIENTS, format ["ASHPD_CF_%1", clientOwner]];
			ASHPD_VAR_CAM_FOLLOW = false;
		};
	};
	
	// Orient portal opposite of the surface normal, vectorUp derived from ASHPD_fnc_GetSurfaceUpVec
	_newPortalObj setVectorDirAndUp [_surfNormal vectorMultiply -1, _surfVectorUp];
	
	// Open new portal
	[_newPortalObj, true] call ASHPD_fnc_SetPortalOpen;
	
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