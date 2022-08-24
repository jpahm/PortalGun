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

/// Description: Controls the portal opening/closing.
/// Parameters:
///		PARAMETER		|		EXPECTED INPUT TYPE		|		DESCRIPTION
///
///		portalObj		|		Object					|		The portal being opened/closed.
///		opening			|		Bool					|		Whether the portal is opening or not.
///
///	Return value: None.

#ifdef ASHPD_DEBUG
ASHPD_LOG_FUNC("SetPortalOpen");
#endif

_this spawn {

	params[["_portalObj", objNull, [objNull]], ["_opening", true, [true]]];

	if (_opening) then {
		_portalObj animateSource ["Portal_Grow_Source", 0, true];
		_portalObj animateSource ["Portal_Grow_Source", 1, 1];
	} else {
		_portalObj animateSource ["Portal_Grow_Source", 1, true];
		_portalObj animateSource ["Portal_Grow_Source", 0, 1];
		sleep 0.25;
		detach _portalObj;
		_portalObj setPosWorld ASHPD_DISABLED_POS;
		(_portalObj getVariable "soundSource") setPosWorld ASHPD_DISABLED_POS;
		ASHPD_HIDE_SERVER(_portalObj, true);
	};

	_portalObj setVariable ["open", _opening];
	// Update portals
	[] call ASHPD_fnc_UpdatePortals;
};