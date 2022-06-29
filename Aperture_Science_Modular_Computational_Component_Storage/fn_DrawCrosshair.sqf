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

/// Description: Handles drawing the crosshair.
/// Parameters: None.
///	Return value: None.

// Adapted from https://github.com/darkChozo/fa_crosshair

// Don't show crosshair if player has it disabled
if (PG_VAR_CROSSHAIR_ENABLED) then {

	private _showCrosshair = false;

	// Should crosshair be shown for animation? Animations in order: stopped, tactical pace, walking, deployed, FFV, limping, diving, bottom diving, surface diving
	{
		if ([_x,animationState player] call BIS_fnc_inString) exitWith {_showCrosshair = true};
	} forEach [
		"MstpSrasW",
		"MtacSrasW",
		"MwlkSrasW",
		"bipod",
		"aim",
		"MlmpSrasW",
		"AdvePercMstpSnonWrfl",
		"AbdvPercMstpSnonWrfl",
		"AsdvPercMstpSnonWrfl"
	];
	
	if (!_showCrosshair) exitWith {};

	// Only show crosshair if player alive, player not aiming down sights, animation correct and player has crosshair enabled
	if (alive player && {cameraView in ["INTERNAL", "EXTERNAL"]}) then {
		private _posLaser = [0,0,0];
		private _right = [0,0,0];
		private _up = [0,0,0];
		private _forward = [0,0,0];

		// To estimate muzzle position, primary weapons (rifles) use the Weapon mempoint, pistols + launchers use RightHand mempoint.
		// Weapon is more accurate but only tracks the primary weapon.
		if (currentWeapon player == primaryWeapon player) then {
			_posLaser = AGLToASL (player modelToWorld (player selectionPosition "Weapon"));

			_right = _posLaser vectorFromTo AGLToASL (player modelToWorld (player selectionPosition "RightHand"));
			_forward = player weaponDirection currentWeapon player;
			_up = _right vectorCrossProduct _forward;
			_right = _forward vectorCrossProduct _up;
		};

		{
			_posLaser = _posLaser vectorAdd (_x vectorMultiply ([0.67, 0.77, 0.035] select _forEachIndex));
		} forEach [_right, _forward, _up];

		// Raycast collision check; up to PG_VAR_MAX_RANGE
		private _posXhair = _posLaser vectorAdd (_forward vectorMultiply PG_VAR_MAX_RANGE);
		private _hitLaser = lineIntersectsSurfaces [_posLaser, _posXhair, player];

		if (count _hitLaser > 0) then {
			// If there's a hit, display crosshair
			private _arXhair = ASLToAGL ((_hitLaser select 0) select 0);
			private _scale = safeZoneW * safeZoneW * PG_VAR_CROSSHAIR_SCALE;
			drawIcon3D [
				PG_VAR_CROSSHAIR_IMAGE,
				[1,1,1,1],
				_arXhair,
				_scale,
				_scale,
				0
			];
		};
	};
};