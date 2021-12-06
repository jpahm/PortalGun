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

/// Description: Handles teleportation through portals.
/// Parameters:
///		PARAMETER		|		EXPECTED INPUT TYPE		|		DESCRIPTION
///
///		bPortal			|		Object					|		The blue portal.
///		oPortal			|		Object					|		The orange portal.
///
///	Return value: None.

params["_bPortal", "_oPortal"];

// Get all the teleportable objects near both portals
private _near = [_bPortal, _oPortal] call PG_fnc_DetectObjects;
private _nearBlue = _near#0;
private _nearOrange = _near#1;

// Exit if we don't have anything to teleport
if (count _nearBlue == 0 && {count _nearOrange == 0}) exitWith {};

{
	_x params ["_nearObjs", "_curPortal", "_otherPortal"];
	
	private ["_curPos", "_otherPos", "_curDir", "_otherDir", "_curUp", "_otherUp", "_curX", "_otherX"];
	_curPos = getPosWorld _curPortal;
	_otherPos = getPosWorld _otherPortal;
	_curDir = vectorDir _curPortal;
	_otherDir = vectorDir _otherPortal;
	_curUp = vectorUp _curPortal;
	_otherUp = vectorUp _otherPortal;
	_curX = _curDir vectorCrossProduct _curUp;
	_otherX = _otherDir vectorCrossProduct _otherUp;
	
	{
		_x params ["_object", "_velocity", "_isProjectile"];
		
		private _posVector = [];
		private _objDir = vectorDir _object;
		private _objUp = vectorUp _object;
		private _objPos = getPosWorld _object;
		private _curIncline = acos((_curDir vectorMultiply -1) vectorCos [0, 0, 1]);
		private _otherIncline = acos((_otherDir vectorMultiply -1) vectorCos [0, 0, 1]);
		
		// Raycast to determine projectile trajectory
		private _rayCast = lineIntersectsSurfaces [_objPos, _objPos vectorAdd ((_velocity) vectorMultiply PG_VAR_MAX_RANGE), _object, objNull, false, 2, "GEOM", "VIEW"];
		private _portalIndex = _rayCast findIf {(_x#2) isEqualTo _curPortal};
		
		// If raycast check passed, use raycast data for positioning
		if (_portalIndex > -1) then {
			_posVector = [((_rayCast#_portalIndex)#0) vectorDiff _curPos, _curDir] call PG_fnc_RestrictVector;
		} else { // Else, compute position as a simple offset from the portal
			_posVector = [_objPos vectorDiff _curPos, _curDir] call PG_fnc_RestrictVector;
		};
		
		// Add gravitational velocity for non-projectiles
		if (!_isProjectile) then {
			if (_curIncline < PG_VAR_VERTICAL_TOLERANCE) then {
				if (_velocity#2 == 0) then {
					_velocity set [2, -PG_VAR_FALL_VELOCITY];
				} else {
					if (_velocity#2 > 0) then {
						_velocity set [2, -(PG_VAR_FALL_VELOCITY) + (_velocity#2)];
					};
				};
			};
		};

		private _dirOffsetPos = acos(_posVector vectorCos _curX);
		private _upOffsetPos = acos(_posVector vectorCos _curUp);
		
		// Transform position between portals
		private _outPos = _otherDir vectorMultiply (vectorMagnitude _posVector);
		_outPos = [_outPos, _otherUp, 90 - _dirOffsetPos] call SUS_fnc_QRotateVec;
		_outPos = [_outPos, _otherX, 90 + _upOffsetPos] call SUS_fnc_QRotateVec;
		_outPos = _otherPos vectorAdd _outPos;

		private _dirOffsetVel = acos(_velocity vectorCos _curX);
		private _upOffsetVel = acos(_velocity vectorCos _curUp);

		// Transform velocity between portals
		private _outVel = _otherDir vectorMultiply (vectorMagnitude _velocity);
		_outVel = [_outVel, _otherUp, 90 - _dirOffsetVel] call SUS_fnc_QRotateVec;
		_outVel = [_outVel, _otherX, 90 + _upOffsetVel] call SUS_fnc_QRotateVec;
		
		// If projectile, add the original projectile to PG_VAR_TP_CACHE and create the new projectile
		if (_isProjectile) then {
			PG_VAR_TP_CACHE pushBack _object;
			_object = createVehicle [(typeOf _object), [1000,1000,1000], [], 0, "CAN_COLLIDE"];
			_outPos = _outPos vectorAdd (_otherDir vectorMultiply -0.05);
		} else {
			_outPos = _outPos vectorAdd (_otherDir vectorMultiply -1);
		};
		
		// Transform direction between portals
		private _outDir = [];
		if ((_velocity vectorCos _objDir) < 0) then {
			_outDir = [_otherDir, _objUp, 90 - acos(_curX vectorCos _objDir)] call SUS_fnc_QRotateVec;
		} else {
			_outDir = [_otherDir, _objUp, 90 + acos(_curX vectorCos _objDir)] call SUS_fnc_QRotateVec;
		};
		
		// Add object to PG_VAR_TP_CACHE, set new pos, direction, and velocity
		PG_VAR_TP_CACHE pushBack _object;
		_object setPosWorld _outPos;
		_object setVectorDir _outDir;
		_object setVelocity _outVel;
		
		false;
	} count _nearObjs;
	false;
} count [
	[_nearBlue, _bPortal, _oPortal], 
	[_nearOrange, _oPortal, _bPortal]
];