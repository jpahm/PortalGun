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

/// Description: Function to be called on each frame after being added to a client via remoteExec.
///				Handles updating local functions that take remote parameters, such as PG_fnc_DoTeleport.
/// Parameters:
///		PARAMETER		|		EXPECTED INPUT TYPE		|		DESCRIPTION
///
///		bPortal			|		Object					|		The (remote) blue portal.
///		oPortal			|		Object					|		The (remote) orange portal.
///
///	Return value: None.

_this call PG_fnc_DoTeleport;
_this call PG_fnc_DoCamIllusion;