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

/// Description: Animates the portal opening/closing. Needs to be remoteExec'd.
/// Parameters:
///		PARAMETER		|		EXPECTED INPUT TYPE		|		DESCRIPTION
///
///		portalObj		|		Object					|		The portal being animated.
///		bPortal			|		Object					|		The blue portal.
///		oPortal			|		Object					|		The orange portal.
///		opening			|		Bool					|		Whether the portal is opening or not.
///
///	Return value: None.

params[["_portalObj", objNull, [objNull]], ["_bPortal", objNull, [objNull]], ["_oPortal", objNull, [objNull]], ["_opening", true, [true]]];

private _isLocal = local _portalObj;
// If animation currently in progress, terminate it
if (_isLocal && {!(PG_VAR_ANIM_HANDLE isEqualTo objNull)}) then {
	terminate PG_VAR_ANIM_HANDLE;
};
private _handle = _this spawn {
	params[["_portalObj", objNull, [objNull]], ["_bPortal", objNull, [objNull]], ["_oPortal", objNull, [objNull]], ["_opening", true, [true]]];
	if (local _portalObj) then {
		private _startRot = [vectorDir _portalObj, vectorUp _portalObj]; // Conserve initial rotation
		private _increment = 0.05;
		private _sleepTime = _increment * 0.25;
		if (!_opening) then {
			private _sizeRatio = 1;
			while {_sizeRatio > 0} do {
				_sizeRatio = _sizeRatio - _increment;
				_portalObj setObjectScale _sizeRatio;
				uiSleep _sleepTime;
			};
		} else {
			private _sizeRatio = 0;
			while {_sizeRatio < 1} do {
				_sizeRatio = _sizeRatio + _increment;
				_portalObj setObjectScale _sizeRatio;
				uiSleep _sleepTime;
			};
		};
		_portalObj setVectorDirAndUp _startRot; // Apply initial rotation
	};
	
	// Reset cameras
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
};
if (_isLocal) then {
	PG_VAR_ANIM_HANDLE = _handle;
};