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
	// The position of the current portal
	_curPos = getPosWorld _curPortal;
	// Position of the other portal
	_otherPos = getPosWorld _otherPortal;
	// Direction of the current portal (points into the portal)
	_curDir = vectorDir _curPortal;
	// Direction of the other portal (points into the portal)
	_otherDir = vectorDir _otherPortal;
	// Direction of the top of the current portal
	_curUp = vectorUp _curPortal;
	// Direction of the top of the other portal
	_otherUp = vectorUp _otherPortal;
	// Direction to the side of the current portal
	_curX = _curDir vectorCrossProduct _curUp;
	// Direction to the side of the other portal
	_otherX = _otherDir vectorCrossProduct _otherUp;
	
	{
		_x params ["_object", "_velocity", "_isProjectile"];
		
		private _posVector = [];
		private _objDir = vectorDir _object;
		private _objUp = vectorUp _object;
		private _objPos = getPosWorld _object;
		private _isMan = _object isKindOf "Man";
		
		// Raycast to determine trajectory
		private _rayCast = lineIntersectsSurfaces [_objPos, _objPos vectorAdd ((_velocity) vectorMultiply PG_VAR_MAX_RANGE), _object, objNull, false, 2, "VIEW", "GEOM"];
		private _portalIndex = _rayCast findIf {(_x#2) isEqualTo _curPortal};
		
		// If raycast check passed, use raycast data for positioning
		if (_portalIndex > -1) then {
			_posVector = [((_rayCast#_portalIndex)#0) vectorDiff _curPos, _curDir] call PG_fnc_ProjectVector;
		} else { // Else, compute position as a simple offset from the portal center, less precise than above
			_posVector = [_objPos vectorDiff _curPos, _curDir] call PG_fnc_ProjectVector;
		};
		
		// Add gravitational acceleration for non-projectiles
		if (!_isProjectile) then {
			// Only accelerate object if incline of surface is within vertical tolerance
			if (acos((_curDir vectorMultiply -1) vectorCos [0, 0, 1]) < PG_VAR_VERTICAL_TOLERANCE) then {
				if (_velocity#2 >= 0) then {
					_velocity set [2, (_velocity#2) - PG_VAR_FALL_VELOCITY];
				};
			};
		};

		private _posCos = _posVector vectorCos _curUp;
		private _upOffsetAngle = [acos(_posCos), -acos(_posCos)] select (_posCos > 0); 
	   
		// Transform position between portals 
		private _outPos = _otherUp vectorMultiply (vectorMagnitude _posVector); 
		_outPos = [_outPos, _otherDir, _upOffsetAngle] call SUS_fnc_QRotateVec;
		_outPos = _otherPos vectorAdd _outPos;
		
		// Properly space the position away from the portal
		if (_isMan && {acos((_otherDir vectorMultiply -1) vectorCos [0, 0, -1]) < PG_VAR_VERTICAL_TOLERANCE}) then {
			_outPos = _outPos vectorAdd (_otherDir vectorMultiply -1);
		} else {
			if (_isProjectile) then {
				_outPos = _outPos vectorAdd (_otherDir vectorMultiply -0.01);
			} else {
				_outPos = _outPos vectorAdd (_otherDir vectorMultiply -0.25);
			};
		};

		// Project the velocity vector onto 3 planes for transform
		//private _projectedVelocityPlane = [_velocity, _curDir] call PG_fnc_ProjectVector;
		private _projectedVelocityDir = [_velocity, _curUp] call PG_fnc_ProjectVector;
		private _projectedVelocityUp = [_velocity, _curX] call PG_fnc_ProjectVector;
		
		// Find the angular offset of each projected vector
		//private _planeOffsetVel = acos(_projectedVelocityPlane vectorCos _curUp);
		private _dirOffsetVel = acos(_projectedVelocityDir vectorCos _curX);
		private _upOffsetVel = acos(_projectedVelocityUp vectorCos _curUp);

		// Transform velocity between portals
		private _outVel = _otherDir vectorMultiply (vectorMagnitude _velocity);
		_outVel = [_outVel, _otherUp, 90 - _dirOffsetVel] call SUS_fnc_QRotateVec;
		_outVel = [_outVel, _otherX, 90 + _upOffsetVel] call SUS_fnc_QRotateVec;
		//_outVel = [_outVel, _otherDir, _planeOffsetVel] call SUS_fnc_QRotateVec;
		
		// If projectile, add the original projectile to PG_VAR_TP_CACHE and create the new projectile
		if (_isProjectile) then {
			PG_VAR_TP_CACHE pushBack _object;
			_object = createVehicle [(typeOf _object), [1000,1000,1000], [], 0, "CAN_COLLIDE"];
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
		// Handle placement of non-unit vehicles
		if (_object isKindOf "AllVehicles" && {!_isMan}) then {
			// Find a spot where a copy of the vehicle fits so nothing goes horribly, horribly wrong
			private _testPos = _outPos vectorAdd (_otherDir vectorMultiply -((boundingBoxReal _object)#2) * 3/4);
			private _testObj = createVehicle [typeOf _object, _testPos];
			private _newPos = getPosWorld _testObj;
			// Delete copy of vehicle
			deleteVehicle _testObj;
			// Fix Z coordinate since it isn't properly found from above testing
			_newPos set [2, _testPos#2];
			// Move actual vehicle
			_object setPosWorld _newPos;
		} else { // Handle placement of anything else
			_object setPosWorld _outPos;
		};
		_object setVectorDir _outDir;
		_object setVelocity _outVel;
		
		false;
	} count _nearObjs;
	false;
} count [
	[_nearBlue, _bPortal, _oPortal], 
	[_nearOrange, _oPortal, _bPortal]
];