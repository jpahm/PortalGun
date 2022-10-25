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

/// Description: Adds or removes items from the server's "garbage collector" for the player matching the given UID. Must be remoteExecuted on the server.
/// Parameters:
///		PARAMETER		|		EXPECTED INPUT TYPE		|		DESCRIPTION
///
///		UID				|		String					|		A player's UID.
///		Objects			|		Array					|		The global objects to add/remove from the garbage collector.
///		Adding			|		Boolean					|		Whether the objects are being added or not.
///
///	Return value: None.

#ifdef ASHPD_DEBUG
ASHPD_LOG_FUNC("UpdateGC");
#endif

params ["_uID", ["_objects", [], [[]]], ["_adding", true, [true]]];

if !(_uID in ASHPD_VAR_GC) then {
	if (_adding) then {
		ASHPD_VAR_GC set [_uID, _objects];
	};
} else {
	if (_adding) then {
		(ASHPD_VAR_GC get _uID) append _objects;
	} else {
		ASHPD_VAR_GC set [_uID, (ASHPD_VAR_GC get _uID) - _objects];
	};
};