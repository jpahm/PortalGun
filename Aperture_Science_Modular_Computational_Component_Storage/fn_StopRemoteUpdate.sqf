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

/// Description: Function that stops periodically updating local functions that take remote parameters. Needs to be remoteExec'd.
/// Parameters:
///		PARAMETER		|		EXPECTED INPUT TYPE		|		DESCRIPTION
///
///		bPortal			|		Object					|		The (remote) blue portal.
///		oPortal			|		Object					|		The (remote) orange portal.
///
///	Return value: None.

#ifdef PG_DEBUG
PG_LOG_FUNC("StopRemoteUpdate");
#endif

params[["_id", "", [""]]];

// Get client's remote update hashmap
private _remoteUpdateHM = missionNameSpace getVariable [format ["PG_RU_%1", remoteExecutedOwner], createHashMapFromArray []];

// Terminate remote client's remote updates
private _scriptHandle = _remoteUpdateHM get _id;
if !(isNull _scriptHandle) then {
	terminate _scriptHandle;
	_remoteUpdateHM deleteAt _id;
};

// Update hashmap
missionNameSpace setVariable [format ["PG_RU_%1", remoteExecutedOwner], _remoteUpdateHM];