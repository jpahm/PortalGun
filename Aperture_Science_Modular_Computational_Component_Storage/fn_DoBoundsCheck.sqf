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

/// Description: Checks if a portal can fit within an area.
/// Parameters:
///		PARAMETER		|		EXPECTED INPUT TYPE		|		DESCRIPTION
///
///		portalObj		|		Object					|		The portal to be checked.
///		surfVectorUp	|		Vector3D				|		The up vector of the surface, acquired from PG_fnc_GetSurfaceUpVec
///		rayCast			|		Array					|		Raycast data provided by PG_fnc_TrySpawnPortal
///
///	Return value: Bool, whether portal will fit or not.

params["_portalObj", "_surfVectorUp", "_rayCast"];

_rayCast params ["_pos", "_surfNormal", "_hitObject", "_hitObjectParent"];
private _vectorSide = _surfNormal vectorCrossProduct _surfVectorUp;
private _toleranceVector = _surfNormal vectorMultiply PG_VAR_FLAT_TOLERANCE;
private _inverseToleranceVector = _toleranceVector vectorMultiply -1;
private _leftVector = (_vectorSide vectorMultiply PG_VAR_PORTAL_WIDTH_H);
private _rightVector = (_vectorSide vectorMultiply -PG_VAR_PORTAL_WIDTH_H);
private _upVector = (_surfVectorUp vectorMultiply PG_VAR_PORTAL_HEIGHT_H);
private _downVector = (_surfVectorUp vectorMultiply -PG_VAR_PORTAL_HEIGHT_H);
private _portalBlocked = true;
private _tries = PG_VAR_MAX_FIT_TRIES;

// Only try to fit the portal if it's blocked and has fit tries remaining
while {_portalBlocked && {_tries > 0}} do {
	_portalBlocked = false;
	// Do collision checks around the portal location, ensuring surface is not blocked by another object
	{
		private _rayCast = lineIntersectsSurfaces [_pos vectorAdd _x vectorAdd (_surfNormal vectorMultiply 0.025), _pos vectorAdd _x vectorAdd ((_surfNormal vectorMultiply 0.5) vectorDiff _toleranceVector), _portalObj, objNull, true, 1, "GEOM", "VIEW"];
		if (count _rayCast != 0) then {
			_pos = _pos vectorAdd (_x vectorMultiply (-2/PG_VAR_MAX_FIT_TRIES));
			_portalBlocked = true;
			break;
		};
		false;
	} count [_leftVector, _rightVector, _upVector, _downVector];
	// Do depth checks around the portal location, ensuring there is a surface under the portal
	private _depthRayCasts = [];
	{
		private _rayCast = (lineIntersectsSurfaces [_pos vectorAdd _x, _pos vectorAdd _x vectorAdd _inverseToleranceVector, _portalObj, objNull, true, 1, "GEOM", "VIEW"]);
		if (count _rayCast == 0) then {
			_pos = _pos vectorAdd (_x vectorMultiply (-2/PG_VAR_MAX_FIT_TRIES));
			_portalBlocked = true;
			break;
		};
		_depthRayCasts pushBack (_rayCast#0);
		false;
	} count [_leftVector, _rightVector, _upVector, _downVector];
	
	_tries = _tries - 1;
	
	// Don't do any further checks if we already know the portal is blocked
	if (_portalBlocked) then { continue };
	// Make sure the surface under the portal is uniform within PG_VAR_FLAT_TOLERANCE
	if (abs((((_depthRayCasts#0)#0) distance ((_depthRayCasts#1)#0)) - PG_VAR_PORTAL_WIDTH) > PG_VAR_FLAT_TOLERANCE) then {_portalBlocked = true};
	if (abs((((_depthRayCasts#2)#0) distance ((_depthRayCasts#3)#0)) - PG_VAR_PORTAL_HEIGHT) > PG_VAR_FLAT_TOLERANCE) then {_portalBlocked = true};
};

// Update raycast position to adjusted position
_rayCast set [0, _pos];
!_portalBlocked;