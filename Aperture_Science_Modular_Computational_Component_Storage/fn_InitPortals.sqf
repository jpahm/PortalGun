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

/// Description: Sets the portal gun's available portals. One or both params need to be true.
/// Parameters:
///		PARAMETER		|		EXPECTED INPUT TYPE		|		DESCRIPTION
///
///		bPortal			|		Bool					|		Whether firing the blue portal is enabled.
///		oPortal			|		Bool					|		Whether firing the orange portal is enabled.
///
///	Return value: None.

#ifdef PG_DEBUG
PG_LOG_FUNC("InitPortals");
#endif

params[["_bPortal", true, [true]], ["_oPortal", true, [true]]];

if (!_bPortal && {!_oPortal}) then {
	// Error, no portals given, default to dual
	PG_ERROR("$STR_PGUN_EX_NoPortals");
	_bPortal = true;
	_oPortal = true;
}; 

// Save init settings for refresh purposes
PG_VAR_INIT_SETTINGS = [_bPortal, _oPortal];

if (_bPortal && _oPortal) then {
	PG_VAR_CURRENT_PORTAL = PG_VAR_BLUE_PORTAL;
	PG_VAR_OTHER_PORTAL = PG_VAR_ORANGE_PORTAL;
} else { // If single portal mode
	if (_bPortal && {!_oPortal}) then { // If only using blue portal
		PG_VAR_CURRENT_PORTAL = PG_VAR_BLUE_PORTAL;
		PG_VAR_OTHER_PORTAL = PG_VAR_BLUE_PORTAL;
	} else { // If only using orange portal
		PG_VAR_CURRENT_PORTAL = PG_VAR_ORANGE_PORTAL;
		PG_VAR_OTHER_PORTAL = PG_VAR_ORANGE_PORTAL;
	};
};

// Update crosshair to match new portal gun settings
call PG_fnc_UpdateCrosshair;