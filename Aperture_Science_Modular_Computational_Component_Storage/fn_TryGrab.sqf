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

/// Description: Handles toggling the grabber arms.
/// Parameters: None.
///	Return value: Boolean, whether gun is now grabbing something.

private _primaryWeapon = primaryWeapon player;

// If currently grabbing item, drop it
if (PG_VAR_GRABBING) then {
	[player, "gun_hold_stop"] remoteExecCall ["say3D"];
	terminate PG_VAR_GRAB_HANDLE;
	deleteVehicle PG_VAR_GRAB_SS;
	deleteVehicle PG_VAR_GRAB_PARTICLES;
	detach PG_VAR_GRABBED_OBJECT;
	// Reset the zeroing to reset claw positioning
	player setWeaponZeroing [_primaryWeapon, _primaryWeapon, 0];
	player setWeaponZeroing [_primaryWeapon, "OrangePortal", 0];
	PG_VAR_GRABBING = false;
} else { // Not currently grabbing an item
	// Allow an item to be grabbed if portal gun is being used
	if (PG_VAR_GRAB_ENABLED && {(currentWeapon player) isKindOf ["ASHPD_MK_SUS_Base_F", configFile >> "CfgWeapons"]}) then {
		
		private _rightHandPos = [0,0,0];
		private _right = [0,0,0];
		private _up = [0,0,0];
		private _forward = [0,0,0];

		_rightHandPos = AGLToASL (player modelToWorld (player selectionPosition "Weapon"));

		_right = _rightHandPos vectorFromTo AGLToASL (player modelToWorld (player selectionPosition "RightHand"));
		_forward = player weaponDirection currentWeapon player;
		_up = _right vectorCrossProduct _forward;
		_right = _forward vectorCrossProduct _up;

		// Make corrections to hand positioning
		{
			_rightHandPos = _rightHandPos vectorAdd (_x vectorMultiply ([0.67, 0.77, 0.035] select _forEachIndex));
		} forEach [_right, _forward, _up];
		
		// Do a raycast from the hand and check for grabable objects
		private _rayCast = lineIntersectsSurfaces [_rightHandPos, _rightHandPos vectorAdd (_forward vectorMultiply PG_VAR_MAX_GRAB_RANGE), player, objNull, true, 1, "GEOM", "VIEW"];
		_rayCast = _rayCast select {
			private _mass = getMass (_x#2);
			(_mass > 0 && {_mass <= PG_VAR_MAX_GRAB_MASS});
		};

		// If we couldn't find anything to grab, play a sound and exit
		if (count _rayCast == 0) exitWith {
			[player, "gun_hold_fail"] remoteExecCall ["say3D"];
			false;
		};

		// Attach grabbed object
		_rayCast = _rayCast#0;
		PG_VAR_GRABBED_OBJECT = _rayCast#2;
		private _boundingRadius = ((boundingBoxReal PG_VAR_GRABBED_OBJECT)#2)/2;
		PG_VAR_GRABBED_OBJECT attachTo [player, [_boundingRadius + 0.4, 0.1, -(_boundingRadius + 0.4)], "righthand", true];
		PG_VAR_GRABBED_OBJECT setVectorDirAndUp [[0.5,0,0.5], [0,1,0]];
		
		// Attach grab particles
		PG_VAR_GRAB_PARTICLES = "PortalBeams" createVehicle [0,0,0];
		PG_VAR_GRAB_PARTICLES animateSource ["Gun_Lightning_Source", 100000, 1];
		PG_VAR_GRAB_PARTICLES animateSource ["Gun_Lightning_Ball_Source", 100000, 1];
		PG_VAR_GRAB_PARTICLES attachTo [player, [0.01, -0.09, -.05], "righthand", true]; 
		PG_VAR_GRAB_PARTICLES setVectorDirAndUp [[0.5,0,0.5], [0,1,0]];
		
		// Terminate any existing grab code
		if (!(PG_VAR_GRAB_HANDLE isEqualTo objNull)) then {
			terminate PG_VAR_GRAB_HANDLE;
		};
		
		// Play the grab sound and start playing the looping sound after a delay
		PG_VAR_GRAB_HANDLE = [] spawn {
			[player, "gun_hold_start"] remoteExecCall ["say3D"];
			uiSleep 1;
			PG_VAR_GRAB_SS = createSoundSource ["GunHoldSource", getPosWorld player, [], 0];
			PG_VAR_GRAB_HANDLE = [] spawn {
				while {PG_VAR_GRABBING} do {
					PG_VAR_GRAB_SS setPosWorld (getPosWorld player);
					uiSleep 0.01;
				};
			};
		};
		
		// Update the zeroing to animate the claws outwards
		player setWeaponZeroing [_primaryWeapon, _primaryWeapon, 1];
		player setWeaponZeroing [_primaryWeapon, "OrangePortal", 1];
		PG_VAR_GRABBING = true;
	};
};

PG_VAR_GRABBING