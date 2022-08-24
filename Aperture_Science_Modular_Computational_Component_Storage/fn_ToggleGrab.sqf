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

/// Description: Handles toggling the grabber arms.
/// Parameters: None.
///	Return value: Boolean, whether gun is now grabbing something.

#ifdef ASHPD_DEBUG
ASHPD_LOG_FUNC("ToggleGrab");
#endif

private _primaryWeapon = primaryWeapon player;

// If currently grabbing item, drop it
if (ASHPD_VAR_GRABBING) then {
	[player, "gun_hold_stop"] call ASHPD_fnc_PlaySound;
	terminate (player getVariable ["ASHPD_VAR_grabHandle", scriptNull]);
	deleteVehicle (player getVariable ["ASHPD_VAR_grabSoundSource", objNull]);
	deleteVehicle (player getVariable ["ASHPD_VAR_grabBeams", objNull]);
	detach (player getVariable ["ASHPD_VAR_grabObject", objNull]);
	// Reset the zeroing to reset claw positioning
	player setWeaponZeroing [_primaryWeapon, _primaryWeapon, 0];
	ASHPD_VAR_GRABBING = false;
} else { // Not currently grabbing an item
	// Allow an item to be grabbed if grabbing enabled and portal gun is being used
	if (ASHPD_VAR_GRAB_ENABLED && {(currentWeapon player) isKindOf ["ASHPD_MK_SUS_Base_F", configFile >> "CfgWeapons"]}) then {
		
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
		private _rayCast = lineIntersectsSurfaces [_rightHandPos, _rightHandPos vectorAdd (_forward vectorMultiply ASHPD_VAR_MAX_GRAB_RANGE), player, objNull, true, 1, "VIEW", "GEOM"];
		_rayCast = _rayCast select {
			private _mass = getMass (_x#2);
			(_mass > 0 && {_mass <= ASHPD_VAR_MAX_GRAB_MASS});
		};

		// If we couldn't find anything to grab, play a sound and exit
		if (count _rayCast == 0) exitWith {
			[player, "gun_hold_fail"] call ASHPD_fnc_PlaySound;
			false;
		};

		// Attach grabbed object
		_rayCast = _rayCast#0;
		player setVariable ["ASHPD_VAR_grabObject", _rayCast#2];
		private _grabObject = _rayCast#2;
		private _boundingRadius = ((boundingBoxReal _grabObject)#2)/2;
		_grabObject attachTo [player, [_boundingRadius + 0.4, 0.1, -(_boundingRadius + 0.4)], "righthand", true];
		_grabObject setVectorDirAndUp [[0.5,0,0.5], [0,1,0]];
		
		// Attach grab particles
		player setVariable ["ASHPD_VAR_grabBeams", "PortalBeams" createVehicle [0,0,0]];
		private _grabBeams = player getVariable "ASHPD_VAR_grabBeams";
		_grabBeams animateSource ["Gun_Lightning_Source", 100000, 1];
		_grabBeams animateSource ["Gun_Lightning_Ball_Source", 100000, 1];
		_grabBeams attachTo [player, [-0.01, -0.14, 0.01], "righthand", true];  
		_grabBeams setVectorDirAndUp [[0.5,0.05,0.5], [0,1,0]];
		
		// Terminate any existing grab code
		private _grabHandle = player getVariable ["ASHPD_VAR_grabHandle", scriptNull];
		if !(_grabHandle isEqualTo scriptNull) then {
			terminate _grabHandle;
		};
		
		// Play the grab sound and start playing the looping sound after a delay
		player setVariable ["ASHPD_VAR_grabHandle", [] spawn {
			[player, "gun_hold_start"] call ASHPD_fnc_PlaySound;
			uiSleep 1;
			player setVariable ["ASHPD_VAR_grabSoundSource", createSoundSource ["GunHoldSource", getPosWorld player, [], 0]];
			private _grabSoundSource = player getVariable "ASHPD_VAR_grabSoundSource";
			_grabSoundSource attachTo [player, [0,0,0]];
		}];
		
		// Update the zeroing to animate the claws outwards
		player setWeaponZeroing [_primaryWeapon, _primaryWeapon, 1];
		ASHPD_VAR_GRABBING = true;
	};
};

ASHPD_VAR_GRABBING