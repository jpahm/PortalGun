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

/// Description: Inits the "garbage collector" code on the server, making sure various items created for players are properly despawned when they disconnect.
/// Parameters: None.
///	Return value: None.

#ifdef ASHPD_DEBUG
ASHPD_LOG_FUNC("InitGC");
#endif

addMissionEventHandler ["PlayerDisconnected",
{
	params ["_id", "_uid", "_name", "_jip", "_owner", "_idstr"];
	{
		deleteVehicle _x;
	} forEach (ASHPD_VAR_GC getOrDefault [_uid, []]);
	ASHPD_VAR_GC deleteAt _uid;
}];