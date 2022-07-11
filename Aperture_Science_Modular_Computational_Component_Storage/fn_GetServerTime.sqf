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

/// Description: Gets the current time (in seconds) since the server started. Synced for all clients. Works in SP.
/// Parameters: None.
///	Return value: Time (in seconds) since the server started.

#ifdef PG_VERBOSE_DEBUG
PG_LOG_FUNC("GetServerTime");
#endif

if (isMultiplayer) then {
	if (isServer) then {
		serverTime;
	} else {
		[0] remoteExecCall ["estimatedTimeLeft", 2];
		serverTime;
	};
} else {
	diag_tickTime;
};