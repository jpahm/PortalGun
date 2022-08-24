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

#ifdef ASHPD_DEBUG
ASHPD_LOG_FUNC("LinkPortals");
#endif

params["_bPortal", "_oPortal"];

// Don't do anything with the cams if PiP not enabled
if (!isPiPEnabled || {!ASHPD_VAR_PIP_ENABLED}) exitWith {};

// Set up the blue portal textures and cams
_bPortal setObjectMaterial [1, ASHPD_PIP_MAT];
_bPortal setObjectTexture [1, format[ASHPD_BLUE_PIP_TEX, remoteExecutedOwner]];
missionNameSpace setVariable [format["ASHPD_VAR_BCAM%1", remoteExecutedOwner], "camera" camCreate [0,0,0]];

private _orangeDir = vectorDir _oPortal;
private _blueDir = vectorDir _bPortal;
private _orangeUp = vectorUp _oPortal;
private _blueUp = vectorUp _bPortal;

private _blueCam = ASHPD_REMOTE_BLUE_CAM;

_blueCam setPosWorld (getPosWorld _oPortal);
_blueCam setVectorDirAndUp [_orangeDir vectorMultiply -1, _orangeUp];
_blueCam cameraEffect ASHPD_BLUE_PIP_EFFECT; 
_blueCam camSetFov 1;
_blueCam camCommit 0;

// Set up the orange portal textures and cams
_oPortal setObjectMaterial [1, ASHPD_PIP_MAT];
_oPortal setObjectTexture [1, format[ASHPD_ORANGE_PIP_TEX, remoteExecutedOwner]];  
missionNameSpace setVariable [format["ASHPD_VAR_OCAM%1", remoteExecutedOwner], "camera" camCreate [0,0,0]];

private _orangeCam = ASHPD_REMOTE_ORANGE_CAM;

_orangeCam setPosWorld (getPosWorld _bPortal);
_orangeCam setVectorDirAndUp [_blueDir vectorMultiply -1, _blueUp];
_orangeCam cameraEffect ASHPD_ORANGE_PIP_EFFECT; 
_orangeCam camSetFov 1;
_orangeCam camCommit 0;

// Only the owner of the portals should animate them
if (remoteExecutedOwner == clientOwner) then { 
	_bPortal animateSource ["Portal_Noise_Source", 0, true];
	_oPortal animateSource ["Portal_Noise_Source", 0, true];
};