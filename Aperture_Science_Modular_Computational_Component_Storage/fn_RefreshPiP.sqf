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

/// Description: Refreshes the PiP textures. Needs to be remoteExec'd.
/// Parameters:
///		PARAMETER		|		EXPECTED INPUT TYPE		|		DESCRIPTION
///
///		bPortal			|		Object					|		The blue portal.
///		oPortal			|		Object					|		The orange portal.
///
///	Return value: None.

params["_bPortal", "_oPortal"];

// Don't do anything with the cams if PiP not enabled
if (!isPiPEnabled || {!PG_VAR_PIP_ENABLED}) exitWith {};

private _blueCam = PG_REMOTE_BLUE_CAM;
private _orangeCam = PG_REMOTE_ORANGE_CAM;

// If the cameras currently exist, refresh their PiP textures
if (!isNull(_blueCam)) then {
	_bPortal setObjectTexture [1, format[PG_BLUE_PIP_TEX, remoteExecutedOwner]];  
	_blueCam cameraEffect ["Internal", "Back", format["piprenderbp%1", remoteExecutedOwner]];
};
if (!isNull(_orangeCam)) then {
	_oPortal setObjectTexture [1, format[PG_ORANGE_PIP_TEX, remoteExecutedOwner]];
	_orangeCam cameraEffect ["Internal", "Back", format["piprenderop%1", remoteExecutedOwner]]; 
};