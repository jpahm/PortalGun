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

/// Description: Finds the up vector to use for placing portals onto surfaces.
/// Parameters:
///		PARAMETER		|		EXPECTED INPUT TYPE		|		DESCRIPTION
///
///		surfNormal		|		Vector3D				|		The normal vector of the surface.
///
///	Return value: Up vector of surface to use.

#ifdef PG_DEBUG
PG_LOG_FUNC("GetSurfaceUpVec");
#endif

params[["_surfNormal", [], [[]]]];

// Find the incline of the surface
private _incline = acos(_surfNormal vectorCos [0, 0, 1]);
if (_incline > 90) then {
	_incline = 180 - _incline;
};
private _crossVector = [];

// If on non-vertical surface, allow portal to rotate w/ player's view and counteract incline
if (_incline < PG_VAR_VERTICAL_TOLERANCE) then {
	private _camVector = getCameraViewDirection player;
	_crossVector = _surfNormal vectorCrossProduct _camVector;
} else { // Else, simply place portal upright
	_crossVector = _surfNormal vectorCrossProduct [0, 0, 1];
};
// Rotate the normal vector 90 degrees on the cross vector axis to obtain up vector
[_surfNormal, _crossVector, 90] call SUS_fnc_QRotateVec;