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

/// Description: Allows the PiP cameras follow the portals when they're attached to moving objects. Needs to be remoteExec'd.
/// Parameters:
///		PARAMETER		|		EXPECTED INPUT TYPE		|		DESCRIPTION
///
///		bPortal			|		Object					|		The blue portal.
///		oPortal			|		Object					|		The orange portal.
///
///	Return value: None.

params["_bPortal", "_oPortal"];

// Don't do anything if PiP is disabled
if (!isPiPEnabled || {!PG_VAR_PIP_ENABLED}) exitWith {};

private _blueAttached = attachedTo _bPortal;
private _orangeAttached = attachedTo _oPortal;

private _orangeDir = vectorDir _oPortal;
private _blueDir = vectorDir _bPortal;
private _orangeUp = vectorUp _oPortal;
private _blueUp = vectorUp _bPortal;

private _blueCam = PG_REMOTE_BLUE_CAM;
private _orangeCam = PG_REMOTE_ORANGE_CAM;

// If the blue or orange portals are attached to something, move the cams along with the object's velocity
if (!isNull _blueAttached) then {
	private _attachVel = velocity _blueAttached;
	_orangeCam setPosWorld (getPosWorld _bPortal vectorAdd (_attachVel vectorMultiply -0.1));
};
if (!isNull _orangeAttached) then {
	private _attachVel = velocity _orangeAttached;
	_blueCam setPosWorld (getPosWorld _oPortal vectorAdd (_attachVel vectorMultiply -0.1));
};