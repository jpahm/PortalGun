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

/// Description: Checks if a portal can fit within an area.
/// Parameters:
///		PARAMETER		|		EXPECTED INPUT TYPE		|		DESCRIPTION
///
///		portalObj		|		Object					|		The portal to be checked.
///		surfVectorUp	|		Vector3D				|		The up vector of the surface, acquired from PG_fnc_GetSurfaceUpVec
///		rayCast			|		Array					|		Raycast data provided by PG_fnc_TrySpawnPortal
///
///	Return value: Bool, whether portal will fit or not.

#ifdef PG_DEBUG
PG_LOG_FUNC("BoundsCheck");
#endif

params["_portalObj", "_surfVectorUp", "_rayCast"];

_rayCast params ["_pos", "_surfNormal", "_hitObject", "_hitObjectParent"];
// Vector parallel to the surface, points to the portal's side
private _vectorSide = _surfNormal vectorCrossProduct _surfVectorUp;
// Vector normal to the surface of length PG_VAR_FLAT_TOLERANCE
private _toleranceVector = _surfNormal vectorMultiply PG_VAR_FLAT_TOLERANCE;
// Inverse vector of _toleranceVector
private _inverseToleranceVector = _toleranceVector vectorMultiply -1;
// _vectorSide of length PG_VAR_PORTAL_WIDTH_H (may not actually be left)
private _leftVector = (_vectorSide vectorMultiply PG_VAR_PORTAL_WIDTH_H);
// Inverse vector of _leftVector (may not actually be right)
private _rightVector = (_leftVector vectorMultiply -1);
// Vector parallel to the surface, points toward the top of the portal
private _upVector = (_surfVectorUp vectorMultiply PG_VAR_PORTAL_HEIGHT_H);
// Inverse vector of _upVector, points toward the bottom of the portal
private _downVector = (_surfVectorUp vectorMultiply -PG_VAR_PORTAL_HEIGHT_H);

// Whether the portal is blocked from spawning in its current location
private _portalBlocked = true;
// # of bound check tries before we give up trying to spawn the portal
private _tries = PG_VAR_MAX_FIT_TRIES;

// Automatically fail if we're going to overlap another portal
private _overlappingPortals = ((ASLtoAGL _pos) nearObjects ["Portal", PG_VAR_PORTAL_WIDTH]) select {_x != _portalObj};
if (count _overlappingPortals != 0) exitWith { false };

// Only try to fit the portal if it's blocked and has fit tries remaining
while {_portalBlocked && {_tries > 0}} do {
	
	// The portal isn't blocked until proven otherwise
	_portalBlocked = false;
	
	// Do collision checks around the portal location, ensuring surface is not blocked by another object
	{
		private _rayCast = lineIntersectsSurfaces [_pos vectorAdd _x vectorAdd (_surfNormal vectorMultiply 0.025), _pos vectorAdd _x vectorAdd ((_surfNormal vectorMultiply 0.55) vectorDiff _toleranceVector), _portalObj, objNull, true, 1, "VIEW", "GEOM"];
		if (count _rayCast != 0) then {
			_pos = _pos vectorAdd (_x vectorMultiply (-2/PG_VAR_MAX_FIT_TRIES));
			_portalBlocked = true;
			break;
		};
	} forEach [_leftVector, _rightVector, _upVector, _downVector];
	
	// Do depth checks around the portal location, ensuring there is a surface under the portal
	private _depthRayCasts = [];
	{
		private _rayCast = (lineIntersectsSurfaces [_pos vectorAdd _x, _pos vectorAdd _x vectorAdd _inverseToleranceVector, _portalObj, objNull, true, 1, "VIEW", "GEOM"]);
		if (count _rayCast == 0) then {
			_pos = _pos vectorAdd (_x vectorMultiply (-2/PG_VAR_MAX_FIT_TRIES));
			_portalBlocked = true;
			break;
		};
		_depthRayCasts pushBack (_rayCast#0);
	} forEach [_leftVector, _rightVector, _upVector, _downVector];
	
	// That's all for this try
	_tries = _tries - 1;
	
	// Don't do any further checks if we already know the portal is blocked
	if (_portalBlocked) then { continue };
	// Make sure the surface under the portal is uniform within PG_VAR_FLAT_TOLERANCE
	if (abs((((_depthRayCasts#0)#0) distance ((_depthRayCasts#1)#0)) - PG_VAR_PORTAL_WIDTH) > PG_VAR_FLAT_TOLERANCE) then {_portalBlocked = true};
	if (abs((((_depthRayCasts#2)#0) distance ((_depthRayCasts#3)#0)) - PG_VAR_PORTAL_HEIGHT) > PG_VAR_FLAT_TOLERANCE) then {_portalBlocked = true};
};

// Update raycast position to adjusted position
_rayCast set [0, _pos];
// Return true if portal not blocked
!_portalBlocked;