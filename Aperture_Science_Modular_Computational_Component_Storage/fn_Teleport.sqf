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

#ifdef ASHPD_VERBOSE_DEBUG
ASHPD_LOG_FUNC("Teleport");
#endif

params["_bPortal", "_oPortal"];

// Get all the teleportable objects near both portals
private _near = [_bPortal, _oPortal] call ASHPD_fnc_DetectObjects;
private _nearBlue = _near#0;
private _nearOrange = _near#1;

// Exit if we don't have anything to teleport
if (count _nearBlue == 0 && {count _nearOrange == 0}) exitWith {};

// Variables for outer loop
private ["_curPos", "_otherPos", "_curDir", "_otherDir", "_curUp", "_otherUp", "_curX", "_otherX"];
// Variables for inner loop
private ["_posVector", "_objDir", "_objUp", "_objPos", "_isMan", "_rayCast", "_portalIndex", "_modelOffsetPos", "_outPos", "_sizeArr", "_modelOffsetVel", "_outVel", "_curAngle", "_otherAngle", "_outDir", "_modelOffsetUp", "_outUp"];

{
	_x params ["_nearObjs", "_curPortal", "_otherPortal"];

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
		
		_objDir = vectorDir _object;
		_objUp = vectorUp _object;
		_objPos = getPosWorld _object;
		_isMan = _object isKindOf "CAManBase";
		
		// Raycast to determine trajectory
		_rayCast = lineIntersectsSurfaces [_objPos, _objPos vectorAdd ((_velocity) vectorMultiply ASHPD_VAR_MAX_RANGE), _object, objNull, false, 2, "VIEW", "GEOM"];
		_portalIndex = _rayCast findIf {(_x#2) isEqualTo _curPortal};
		// If raycast check passed, use raycast data for positioning
		if (_portalIndex > -1) then {
			_posVector = _curPos vectorDiff ((_rayCast#_portalIndex)#0);
		} else { // Else, compute position as a simple offset from the portal center, less precise than above
			_posVector = _curPos vectorDiff _objPos;
		};
		
		// Add gravitational acceleration for non-projectiles
		if (!_isProjectile) then {
			// Only accelerate object if incline of surface is within vertical tolerance upwards
			if (acos(_curDir vectorCos [0, 0, -1]) < ASHPD_VAR_VERTICAL_TOLERANCE) then {
				if (_velocity#2 >= 0) then {
					_velocity set [2, (_velocity#2) - ASHPD_VAR_FALL_VELOCITY];
				};
			};
		};
		
		// Transform positioning between portals by rotating the projected position vector 180 degrees around the portal's dirVector
		_modelOffsetPos = _curPortal vectorWorldToModel 
		([
			// Add horizontal and vertical vectors, only mirror horizontal vector
			(([_posVector, _curUp] call ASHPD_fnc_ProjectVector) vectorMultiply -1) vectorAdd ([_posVector, _curX] call ASHPD_fnc_ProjectVector),
			_curDir,
			180
		] call SUS_fnc_QRotateVec);
		_outPos = _otherPos vectorAdd (_otherPortal vectorModelToWorld _modelOffsetPos);
		
		// Use boundingBox dimensions to properly space object from exit portal
		(boundingBoxReal _object) params ["_minArr", "_maxArr"];
		if (_isMan && {acos(_otherDir vectorCos [0, 0, -1]) < ASHPD_VAR_VERTICAL_TOLERANCE}) then {
			_sizeArr = (_maxArr vectorAdd (_minArr vectorMultiply -1)) vectorMultiply 0.05;
		} else {
			_sizeArr = (_maxArr vectorAdd (_minArr vectorMultiply -1)) vectorMultiply .75;
		};
		_outPos = _outPos vectorAdd (_otherDir vectorMultiply -(vectorMagnitude ([[_sizeArr, _otherX] call ASHPD_fnc_ProjectVector, _otherUp] call ASHPD_fnc_ProjectVector)));
		
		// Transform the velocity between portals by rotating the velocity vector 180 degrees around the portal's upVector
		_modelOffsetVel = _curPortal vectorWorldToModel ([_velocity, _curUp, 180] call SUS_fnc_QRotateVec);
		_outVel = _otherPortal vectorModelToWorld _modelOffsetVel;
		
		// Calculate portal angles for direction transformation
		_curAngle = acos(_curDir vectorCos [0, 0, 1]);
		_curAngle = [_curAngle, 180 - _curAngle] select (_curAngle > 90);
		_otherAngle = acos(_otherDir vectorCos [0, 0, 1]);
		_otherAngle = [_otherAngle, 180 - _otherAngle] select (_otherAngle > 90);
		
		// Transform direction based on velocity if only the entrance portal is facing straight up/down
		if (_curAngle < 1 && _otherAngle >= 1) then {
			_outDir = vectorNormalized _outVel;
		// Else, perform normal direction transformation
		} else {
			_modelOffsetDir = _curPortal vectorWorldToModel ([_objDir, _curUp, 180] call SUS_fnc_QRotateVec);
			_outDir = _otherPortal vectorModelToWorld _modelOffsetDir;
		};
		
		// If projectile, create a new projectile at outpos
		if (_isProjectile) then {
			_object = createVehicle [(typeOf _object), _outPos, [], 0, "NONE"];
		};
		
		// Set new pos, direction, and velocity
		
		// Handle placement of non-unit vehicles
		if (_object isKindOf "AllVehicles" && {!_isMan}) then {
			// Find a spot where a copy of the vehicle fits so nothing goes horribly, horribly wrong
			private _testObj = createVehicle [typeOf _object, _outPos];
			private _tempPos = _outPos;
			_outPos = getPosWorld _testObj;
			// Delete copy of vehicle
			deleteVehicle _testObj;
			// Fix Z coordinate since it isn't properly found from above testing
			_outPos set [2, _tempPos#2];
		};
		
		// Move object to new position
		_object setPosWorld _outPos;
		
		if (_isMan) then {
			// Only set direction for units
			_object setVectorDir _outDir;
		} else {
			// Transform the object's up direction between portals with a 180 degree upVector rotation
			_modelOffsetUp = _curPortal vectorWorldToModel ([_objUp, _curUp, 180] call SUS_fnc_QRotateVec);
			_outUp = _otherPortal vectorModelToWorld _modelOffsetUp;
			_object setVectorDirAndUp [_outDir, _outUp];
		};
		
		_object setVelocity _outVel;
		
	} forEach _nearObjs;
} forEach [
	[_nearBlue, _bPortal, _oPortal], 
	[_nearOrange, _oPortal, _bPortal]
];