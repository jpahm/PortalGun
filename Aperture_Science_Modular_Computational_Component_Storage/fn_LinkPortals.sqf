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

/// Description: "Links" the portals by setting up the cameras for PiP. Should be remoteExec'd.
/// Parameters:
///		PARAMETER		|		EXPECTED INPUT TYPE		|		DESCRIPTION
///
///		bPortal			|		Object					|		The blue portal.
///		oPortal			|		Object					|		The orange portal.
///
///	Return value: None.

#ifdef PG_DEBUG
PG_LOG_FUNC("LinkPortals");
#endif

params["_bPortal", "_oPortal"];

// Don't do anything with the cams if PiP not enabled
if (!isPiPEnabled || {!PG_VAR_PIP_ENABLED}) exitWith {};

// Set up the blue portal and cams
_bPortal animateSource ["Portal_Noise_Source", 0, true];
_bPortal setObjectMaterial [1, PG_PIP_MAT];
_bPortal setObjectTexture [1, format[PG_BLUE_PIP_TEX, remoteExecutedOwner]];
missionNameSpace setVariable [format["PG_VAR_BLUE_CAM_%1", remoteExecutedOwner], "camera" camCreate [0,0,0]];

private _orangeDir = vectorDir _oPortal;
private _blueDir = vectorDir _bPortal;
private _orangeUp = vectorUp _oPortal;
private _blueUp = vectorUp _bPortal;

private _blueCam = PG_REMOTE_BLUE_CAM;

_blueCam setPosWorld (getPosWorld _oPortal);
_blueCam setVectorDirAndUp [_orangeDir vectorMultiply -1, _orangeUp];
_blueCam cameraEffect ["Internal", "Back", format["piprenderbp%1", remoteExecutedOwner]]; 
_blueCam camSetFov 1;
_blueCam camCommit 0;

// Set up the orange portal and cams
_oPortal animateSource ["Portal_Noise_Source", 0, true];
_oPortal setObjectMaterial [1, PG_PIP_MAT];
_oPortal setObjectTexture [1, format[PG_ORANGE_PIP_TEX, remoteExecutedOwner]];  
missionNameSpace setVariable [format["PG_VAR_ORANGE_CAM_%1", remoteExecutedOwner], "camera" camCreate [0,0,0]];

private _orangeCam = PG_REMOTE_ORANGE_CAM;

_orangeCam setPosWorld (getPosWorld _bPortal);
_orangeCam setVectorDirAndUp [_blueDir vectorMultiply -1, _blueUp];
_orangeCam cameraEffect ["Internal", "Back", format["piprenderop%1", remoteExecutedOwner]]; 
_orangeCam camSetFov 1;
_orangeCam camCommit 0;