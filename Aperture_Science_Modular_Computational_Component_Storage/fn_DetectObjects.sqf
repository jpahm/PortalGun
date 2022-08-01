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

/// Description: Performs object detection for portal teleportation.
/// Parameters:
///		PARAMETER		|		EXPECTED INPUT TYPE		|		DESCRIPTION
///
///		bPortal			|		Object					|		The blue portal.
///		oPortal			|		Object					|		The orange portal.
///
///	Return value: Array of arrays in format [[object, velocity, isProjectile]].

#ifdef PG_VERBOSE_DEBUG
PG_LOG_FUNC("DetectObjects");
#endif

params[["_bPortal", objNull, [objNull]], ["_oPortal", objNull, [objNull]]];

private _nearObjects = [[], []];
{
	private _portalObj = _x;
	private _portalPos = getPosWorld _portalObj;
	private _nearPortal = [];
	private _obj = objNull;
	
	// Detect all projectile types
	{
		private ["_objPos", "_rayCast", "_temp"];
		// Iterate over all projectiles of a given type near the portal
		{
			if !(_x in PG_VAR_TP_CACHE) then {
				_objPos = getPosWorld _x;
				// Do a raycast to make sure we're only grabbing projectiles that are actually entering the portal
				_rayCast = lineIntersectsSurfaces [_objPos, _objPos vectorAdd ((velocity _x) vectorMultiply PG_VAR_MAX_RANGE), player, objNull, true, 2, "VIEW", "GEOM"];
				if ((_rayCast findIf {(_x#2) isKindOf "Portal"}) == 0) then {
					// Delete the original projectile before it hits the portal, save its velocity for later
					_temp = [_x, velocity _x, true]; 
					deleteVehicle _x; 
					_nearPortal pushBack _temp;
				};
			};
		} forEach (_portalObj nearObjects [_x, PG_VAR_PROJECTILE_GRAB_RANGE]);
	} forEach PG_VAR_PROJECTILE_TYPES;
	
	// Detect grenades, PhysX objects, units, and vehicles
	{
		_nearPortal pushBackUnique _x;
	} forEach (_portalObj nearObjects ["Grenade", PG_VAR_MAX_GRAB_RANGE] apply {[_x, velocity _x, false]});
	{
		_nearPortal pushBackUnique _x;
	} forEach (_portalObj nearObjects ["ThingX", PG_VAR_MAX_GRAB_RANGE] apply {[_x, velocity _x, false]});
	{
		_nearPortal pushBackUnique _x;
	} forEach (_portalObj nearObjects ["Man", PG_VAR_UNIT_GRAB_RANGE] apply {[_x, velocity _x, false]});
	{
		private _vehicle = _x#0;
		// Ignore units, those are detected differently above
		if (_vehicle isKindOf "Man") then { continue };
		private _distance = _portalObj distance _vehicle;
		// Bounding sphere diameter
		private _vehicleSize = (boundingBoxReal _vehicle)#2;
		// Only teleport the vehicle if its distance to the portal is less than its bounding diameter
		if (_distance <= _vehicleSize * 3/4) then {
			_nearPortal pushBackUnique _x;
		};
	} forEach (_portalObj nearObjects ["AllVehicles", PG_VAR_VEHICLE_GRAB_RANGE] apply {[_x, velocity _x, false]});
	
	// Filter out portals and portal surfaces
	_nearPortal = _nearPortal select {
		_obj = _x#0;
		!(_obj in _this) && {!(_obj in PG_VAR_PORTAL_SURFACES)}
	};
	_nearObjects set [_forEachIndex, _nearPortal];
	
} forEach [_bPortal, _oPortal];

private _nearBlue = (_nearObjects#0) apply {_x#0};
private _nearOrange = (_nearObjects#1) apply {_x#0};
// Remove objects from the cache that are no longer within the detection range of the portals
PG_VAR_TP_CACHE = PG_VAR_TP_CACHE select {_x in _nearBlue || {_x in _nearOrange}};

// Don't teleport any objects already in PG_VAR_TP_CACHE, add to-be-teleported objects to cache
{
	_nearObjects set [_forEachIndex, _x select {
		_obj = _x#0;
		if !(_obj in PG_VAR_TP_CACHE) then {
			PG_VAR_TP_CACHE append [_obj];
			true;
		} else {
			false;
		};
	}];
} forEach _nearObjects;

_nearObjects;