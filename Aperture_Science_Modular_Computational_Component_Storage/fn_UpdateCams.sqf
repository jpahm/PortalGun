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

/// Description: Moves the portal cameras to their current portal positions.
/// Parameters:
///		PARAMETER		|		EXPECTED INPUT TYPE		|		DESCRIPTION
///
///		bPortal			|		Object					|		The blue portal.
///		oPortal			|		Object					|		The orange portal.
///
///	Return value: None.

params["_bPortal", "_oPortal"];

private _orangeDir = vectorDir _oPortal;
private _blueDir = vectorDir _bPortal;
private _orangeUp = vectorUp _oPortal;
private _blueUp = vectorUp _bPortal;

private _blueCam = PG_REMOTE_BLUE_CAM;
private _orangeCam = PG_REMOTE_ORANGE_CAM;

if (!isNull(_orangeCam)) then {
	_orangeCam setPosWorld (getPosWorld _bPortal);
	_orangeCam setVectorDirAndUp [_blueDir vectorMultiply -1, _blueUp];
};
if (!isNull(_blueCam)) then {
	_blueCam setPosWorld (getPosWorld _oPortal);
	_blueCam setVectorDirAndUp [_orangeDir vectorMultiply -1, _orangeUp];
};