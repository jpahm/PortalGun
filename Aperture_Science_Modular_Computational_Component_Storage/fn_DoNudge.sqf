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

/// Description: Creates the illusion of depth in the portals' PiP views. Needs to be remoteExec'd.
/// Parameters:
///		PARAMETER		|		EXPECTED INPUT TYPE		|		DESCRIPTION
///
///		bPortal			|		Object					|		The blue portal.
///		oPortal			|		Object					|		The orange portal.
///
///	Return value: None.

#ifdef PG_VERBOSE_DEBUG
PG_LOG_FUNC("DoNudge");
#endif

params["_bPortal", "_oPortal"];

// Get the player's position
private _playerPos = getPosWorld player;

{
	private _portal = _x;
	private _portalDir = vectorDir _portal;
	private _portalPos = getPosWorld _portal;
	private _posOffset = _playerPos vectorDiff _portalPos;
	// Ignore if not within range of the player or if the player is not elevated above the portal
	if ((_posOffset#2) < 0.1 || {vectorMagnitude _posOffset > PG_VAR_NUDGE_RANGE}) then { continue };
	// Only check if we need to apply a nudge if the portal isn't vertical and is facing upwards
	private _cos = (_portalDir vectorMultiply -1) vectorCos [0, 0, 1];
	if (_cos > 0 && {acos(_cos) < PG_VAR_VERTICAL_TOLERANCE}) then {
		// Calculate the position correction needed 
		private _posCorrection = ([_posOffset, _portalDir vectorMultiply -1] call PG_fnc_ProjectVector) vectorMultiply -1;
		// Apply slight position correction
		player setPosWorld (_playerPos vectorAdd (_posCorrection vectorMultiply PG_VAR_NUDGE_STRENGTH));
	};
} forEach [_bPortal, _oPortal];