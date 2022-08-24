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

/// Description: Starts the black hole sequence at a given position.
/// Parameters:
///		PARAMETER		|		EXPECTED INPUT TYPE		|		DESCRIPTION
///
///		position		|		PositionWorld			|		The position to spawn the black hole.
///
///	Return value: Spawn handle.

#ifdef ASHPD_DEBUG
ASHPD_LOG_FUNC("BlackHole");
#endif

_this spawn {
	params["_position"];

	// Start playing music on all clients
	["BlackHoleMusic"] remoteExecCall ["playMusic", [0, -2] select ASHPD_VAR_IS_DEDI];

	// Wait 16 seconds, until music intensifies
	sleep 16;

	// Spawn the black hole
	private _blackHole = createVehicle ["death", _position, [], 0, "CAN_COLLIDE"];
	// Init pull range to EH distance
	private _blackHoleRange = ASHPD_VAR_BH_EH_DISTANCE;
	// Gravitational constant * Black hole mass for gravForce calc
	private _GM = 10000000;
	// Pull physX objects into the black hole and destroy them
	while {true} do {
		// Destroy any non-player items that enter the event horizon
		private _destroy = (_position nearObjects ASHPD_VAR_BH_EH_DISTANCE) - [_blackHole];
		{
			_x setDamage 1;
			// Hide object
			ASHPD_HIDE_SERVER(_x, true);
			// Delete all vehicles that aren't units
			if (_x isKindOf "AllVehicles" && {!(_x isKindOf "CAManBase")}) then {
				deleteVehicle _x;
			};
		} forEach _destroy;
		// Pull anything within the current range
		private _pull = (_position nearObjects _blackHoleRange) - [_blackHole];
		{
			private _pos = getPosWorld _x;
			private _forceDir = _pos vectorFromTo _position;
			private _distance =  _pos vectorDistance _position;
			private _objMass = getMass _x;
			private _objCoM = getCenterOfMass _x;
			private _gravForce = _GM * _objMass / (_distance^2); // Fg = GMm/r^2
			_x addForce [_forceDir vectorMultiply _gravForce, _objCoM]; // Apply gravForce to object's CoM toward black hole
		} forEach _pull;
		_blackHoleRange = _blackHoleRange + 2.5; // Increase pull range
		sleep 0.25;
	};
};