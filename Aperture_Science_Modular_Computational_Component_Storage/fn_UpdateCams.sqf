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

/// Description: Moves the portal cameras to their current portal positions on other clients. Must be remoteExec'd.
/// Parameters:
///		PARAMETER		|		EXPECTED INPUT TYPE		|		DESCRIPTION
///
///		bPortalPos		|		PositionWorld			|		The blue portal.
///		blueDir			|		Vector3D				|		The blue portal's vectorDir.
///		blueUp			|		Vector3D				|		The blue portal's vectorUp.
///		oPortalPos		|		PositionWorld			|		The orange portal.
///		orangeDir		|		Vector3D				|		The orange portal's vectorDir.
///		orangeUp		|		Vector3D				|		The orange portal's vectorUp.
///
///	Return value: None.

#ifdef ASHPD_DEBUG
ASHPD_LOG_FUNC("UpdateCams");
#endif

params["_bPortalPos", "_blueDir", "_blueUp", "_oPortalPos", "_orangeDir", "_orangeUp"];

private _blueCam = ASHPD_REMOTE_BLUE_CAM;
private _orangeCam = ASHPD_REMOTE_ORANGE_CAM;

if !(isNull _orangeCam) then {
	_orangeCam setPosWorld _bPortalPos;
	_orangeCam setVectorDirAndUp [_blueDir vectorMultiply -1, _blueUp];
};
if !(isNull _blueCam) then {
	_blueCam setPosWorld _oPortalPos;
	_blueCam setVectorDirAndUp [_orangeDir vectorMultiply -1, _orangeUp];
};