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

/// Description: Creates the illusion of depth in the portals' PiP views. Needs to be remoteExec'd.
/// Parameters:
///		PARAMETER		|		EXPECTED INPUT TYPE		|		DESCRIPTION
///
///		bPortal			|		Object					|		The blue portal.
///		oPortal			|		Object					|		The orange portal.
///
///	Return value: None.

params["_bPortal", "_oPortal"];

private _blueCam = PG_REMOTE_BLUE_CAM;
private _orangeCam = PG_REMOTE_ORANGE_CAM;

// Position of player should remain constant so long as they're standing in the same spot
private _playerPos = (getPosWorld player vectorAdd [0,0,1.5]);

private _relPosBlue = _playerPos vectorDiff (getPosWorld _bPortal);
private _relPosOrange = _playerPos vectorDiff (getPosWorld _oPortal);

private _relPosBMag = vectorMagnitude _relPosBlue;
private _relPosOMag = vectorMagnitude _relPosOrange;

// Constrain the relative positions to a minimum magnitude
if (_relPosBMag < 3) then {
	_relPosBlue = _relPosBlue vectorMultiply (3/_relPosBMag);
};
if (_relPosOMag < 3) then {
	_relPosOrange = _relPosOrange vectorMultiply (3/_relPosOMag);
};

private _blueDir = vectorDir _bPortal;
private _blueUp = vectorUp _bPortal;
private _orangeDir = vectorDir _oPortal;
private _orangeUp = vectorUp _oPortal;

private _blueX = _blueDir vectorCrossProduct _blueUp;
private _orangeX = _orangeDir vectorCrossProduct _orangeUp;

private _dirOffsetBlue = acos(_relPosBlue vectorCos _blueX);
private _upOffsetBlue = acos(_relPosBlue vectorCos (_blueUp vectorMultiply -1));

// Set camera direction as mirrored offsets of the relative position
private _bCamDir = [_orangeDir, _orangeUp, 270 + _dirOffsetBlue] call SUS_fnc_QRotateVec;
_bCamDir = [_bCamDir, _orangeX, 90 + _upOffsetBlue] call SUS_fnc_QRotateVec;

private _dirOffsetOrange = acos(_relPosOrange vectorCos _orangeX);
private _upOffsetOrange = acos(_relPosOrange vectorCos (_orangeUp vectorMultiply -1));

// Set camera direction as mirrored offsets of the relative position
private _oCamDir = [_blueDir, _blueUp, 270 + _dirOffsetOrange] call SUS_fnc_QRotateVec;
_oCamDir = [_oCamDir, _blueX, 90 + _upOffsetOrange] call SUS_fnc_QRotateVec;

// Constrain camera direction
if (acos(_bCamDir vectorCos (_orangeDir vectorMultiply -1)) < 60) then {
	_blueCam setVectorDirAndUp [_bCamDir, _orangeUp];
};
if (acos(_oCamDir vectorCos (_blueDir vectorMultiply -1)) < 60) then {
	_orangeCam setVectorDirAndUp [_oCamDir, _blueUp];
};