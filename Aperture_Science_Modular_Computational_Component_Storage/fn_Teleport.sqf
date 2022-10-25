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

/// Description: Handles teleportation through portals. Meant to be ran via StartRemoteUpdate.
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
([_bPortal, _oPortal] call ASHPD_fnc_DetectObjects) params ["_nearBlue", "_nearOrange"];

// Exit if we don't have anything to teleport
if (count _nearBlue == 0 && {count _nearOrange == 0}) exitWith {};

// Variables for outer loop
private ["_entrancePos", "_exitPos", "_entranceDir", "_exitDir", "_entranceUp", "_exitUp", "_entranceX", "_exitX"];
// Variables for inner loop
private [
	"_objDir", "_objUp", "_objPos", "_isMan", "_isLocal", "_posVector",
	"_modelOffsetPos", "_outPos", "_requiredSize", "_curSize", "_modelOffsetVel", 
	"_outVel", "_entranceAngle", "_exitAngle", "_outDir", "_modelOffsetUp", "_outUp"
];

{
	_x params ["_nearObjs", "_entrancePortal", "_exitPortal"];

	// The position of the current portal
	_entrancePos = getPosWorld _entrancePortal;
	// Position of the other portal
	_exitPos = getPosWorld _exitPortal;
	// Direction of the current portal (points into the portal)
	_entranceDir = vectorDir _entrancePortal;
	// Direction of the other portal (points into the portal)
	_exitDir = vectorDir _exitPortal;
	// Direction of the top of the current portal
	_entranceUp = vectorUp _entrancePortal;
	// Direction of the top of the other portal
	_exitUp = vectorUp _exitPortal;
	// Direction to the side of the current portal
	_entranceX = _entranceDir vectorCrossProduct _entranceUp;
	// Direction to the side of the other portal
	_exitX = _exitDir vectorCrossProduct _exitUp;
	
	{
		_x params ["_object", "_velocity", "_isProjectile"];
		
		_objDir = vectorDir _object;
		_objUp = vectorUp _object;
		_objPos = getPosWorld _object;
		_isMan = (!_isProjectile && {_object isKindOf "CAManBase"});
		_isLocal = local _object;
		// Vector offset of the object's position from the entrance portal
		_posVector = _entrancePos vectorDiff _objPos;
		
		// Add gravitational acceleration for non-projectiles
		if (!_isProjectile) then {
			// Only accelerate object if incline of surface is within vertical tolerance upwards
			if (acos(_entranceDir vectorCos [0, 0, -1]) < ASHPD_VAR_VERTICAL_TOLERANCE) then {
				if (_velocity#2 >= 0) then {
					_velocity set [2, (_velocity#2) - ASHPD_VAR_FALL_VELOCITY];
				};
			};
		};
		
		// Transform positioning between portals by rotating the projected position vector 180 degrees around the portal's dirVector
		_modelOffsetPos = _entrancePortal vectorWorldToModel 
		([
			// Add horizontal and vertical vectors, only mirror horizontal vector
			(([_posVector, _entranceUp] call ASHPD_fnc_ProjectVector) vectorMultiply -1) vectorAdd ([_posVector, _entranceX] call ASHPD_fnc_ProjectVector),
			_entranceDir,
			180
		] call CBA_fnc_vectRotate3D);
		_outPos = _exitPos vectorAdd (_exitPortal vectorModelToWorld _modelOffsetPos);
		
		// Use boundingBox dimensions to properly space object from exit portal
		(boundingBoxReal _object) params ["_minArr", "_maxArr"];
		if (_isMan) then {
			if (acos(_exitDir vectorCos [0, 0, -1]) < ASHPD_VAR_VERTICAL_TOLERANCE) then {
				// Only apply a slight offset for units if the exit faces upwards
				_requiredSize = (_maxArr vectorDiff _minArr) vectorMultiply ASHPD_VAR_OFFSET_UP;
			} else {
				if (acos(_exitDir vectorCos [0, 0, 1]) < ASHPD_VAR_VERTICAL_TOLERANCE) then {
					// Apply a large offset for units if the exit faces downwards
					_requiredSize = (_maxArr vectorDiff _minArr) vectorMultiply ASHPD_VAR_OFFSET_DOWN;
				} else {
					// Otherwise, apply standard unit offset
					_requiredSize = (_maxArr vectorDiff _minArr) vectorMultiply ASHPD_VAR_OFFSET_UNIT;
				};
			};
		} else {
			// Apply standard offset for non-units
			_requiredSize = (_maxArr vectorDiff _minArr) vectorMultiply ASHPD_VAR_OFFSET;
		};
		_curSize = [[_outPos vectorDiff _exitPos, _exitX] call ASHPD_fnc_ProjectVector, _exitUp] call ASHPD_fnc_ProjectVector;
		//_requiredSize = [[_requiredSize, _exitX] call ASHPD_fnc_ProjectVector, _exitUp] call ASHPD_fnc_ProjectVector;
		_outPos = _outPos vectorDiff (
			_exitDir vectorMultiply vectorMagnitude (_requiredSize vectorDiff _curSize)
		);
		
		// Transform the velocity between portals by rotating the velocity vector 180 degrees around the portal's upVector
		_modelOffsetVel = _entrancePortal vectorWorldToModel ([_velocity, _entranceUp, 180] call CBA_fnc_vectRotate3D);
		_outVel = _exitPortal vectorModelToWorld _modelOffsetVel;
		
		// Calculate portal angles for direction transformation
		_entranceAngle = acos(_entranceDir vectorCos [0, 0, 1]);
		_entranceAngle = [_entranceAngle, 180 - _entranceAngle] select (_entranceAngle > 90);
		_exitAngle = acos(_exitDir vectorCos [0, 0, 1]);
		_exitAngle = [_exitAngle, 180 - _exitAngle] select (_exitAngle > 90);
		
		// Check if the entrance portal is non-vertical
		if (_entranceAngle < ASHPD_VAR_VERTICAL_TOLERANCE) then {
			// Transform direction based on velocity if only the entrance portal is non-vertical
			if (_exitAngle >= ASHPD_VAR_VERTICAL_TOLERANCE) then {
				_outDir = vectorNormalized _outVel;
			// Else, if both portals are vertical, keep direction the same
			} else {
				_outDir = _objDir;
			}
		// Else, perform normal direction transformation
		} else {
			_modelOffsetDir = _entrancePortal vectorWorldToModel ([_objDir, _entranceUp, 180] call CBA_fnc_vectRotate3D);
			_outDir = _exitPortal vectorModelToWorld _modelOffsetDir;
		};
		
		// If projectile, create a new projectile at outpos
		if (_isProjectile) then {
			// Mark original projectile as teleported so it gets removed from the cache
			_object setVariable ["ASHPD_TPED", true];
			// Replace projectile with new projectile
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
			if (_isLocal) then {
				_object setVectorDir _outDir;
			} else {
				[_object, _outDir] remoteExecCall ["setVectorDir", _object];
			};
		} else {
			// Transform the object's up direction between portals with a 180 degree upVector rotation
			_modelOffsetUp = _entrancePortal vectorWorldToModel ([_objUp, _entranceUp, 180] call CBA_fnc_vectRotate3D);
			_outUp = _exitPortal vectorModelToWorld _modelOffsetUp;
			if (_isLocal) then {
				_object setVectorDirAndUp [_outDir, _outUp];
			} else {
				[_object, [_outDir, _outUp]] remoteExecCall ["setVectorDirAndUp", _object];
			};
		};
		
		if (_isLocal) then {
			_object setVelocity _outVel;
		} else {
			[_object, _outVel] remoteExecCall ["setVelocity", _object];
		};
		
		// Mark object as teleported (locally)
		_object setVariable ["ASHPD_TPED", true];
		
	} forEach _nearObjs;
} forEach [
	[_nearBlue, _bPortal, _oPortal], 
	[_nearOrange, _oPortal, _bPortal]
];