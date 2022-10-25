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

params[["_portalObj", objNull, [objNull]], ["_opening", true, [true]]];

if (_opening) then {
	if (_portalObj getVariable "isBlue") then {
		[_portalObj, "portal_open_blue"] call ASHPD_fnc_PlaySound;
		_portalObj setObjectTextureGlobal [1, ASHPD_BLUE_NOISE_TEX];
		_portalObj setObjectMaterialGlobal [1, ASHPD_BLUE_NOISE_MAT];
		_portalObj setObjectTextureGlobal [0, ASHPD_BLUE_EDGE_TEX]; 
		_portalObj setObjectMaterialGlobal [0, ASHPD_BLUE_EDGE_MAT];
		_portalObj animateSource ["Portal_Flames_Source", 100000, 1];
		_portalObj animateSource ["Portal_Noise_Source", 100000, 1];
	} else {
		[_portalObj, "portal_open_red"] call ASHPD_fnc_PlaySound;
		_portalObj setObjectTextureGlobal [1, ASHPD_ORANGE_NOISE_TEX];
		_portalObj setObjectMaterialGlobal [1, ASHPD_ORANGE_NOISE_MAT];
		_portalObj setObjectTextureGlobal [0, ASHPD_ORANGE_EDGE_TEX]; 
		_portalObj setObjectMaterialGlobal [0, ASHPD_ORANGE_EDGE_MAT];
		_portalObj animateSource ["Portal_Flames_Source", 100000, 1];
		_portalObj animateSource ["Portal_Noise_Source", 100000, 1];
	};
	_portalObj animateSource ["Portal_Grow_Source", 0, true];
	_portalObj animateSource ["Portal_Grow_Source", 1, 1];
} else {
	detach _portalObj;
	[_portalObj, "portal_fizzle"] call ASHPD_fnc_PlaySound;
	_portalObj animateSource ["Portal_Grow_Source", 1, true];
	_portalObj animateSource ["Portal_Grow_Source", 0, 1];
};

// Set "open" variable
_portalObj setVariable ["open", _opening];

// Update portals
[] call ASHPD_fnc_UpdatePortals;

// Hide/unhide portal depending on whether it's opening or closing
if (_opening) then {
	// Unhide immediately
	ASHPD_HIDE_SERVER(_portalObj, false);
} else {
	_portalObj spawn {
		// Hide after a delay
		sleep 0.25;
		if !(isNull _this) then {
			ASHPD_HIDE_SERVER(_this, true);
			_this setPosWorld ASHPD_DISABLED_POS;
			(_this getVariable "soundSource") setPosWorld ASHPD_DISABLED_POS;
		};
	};
};