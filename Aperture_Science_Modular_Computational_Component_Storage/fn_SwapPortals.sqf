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

/// Description: Handles swapping which portal is active when firemode is changed.
/// Parameters: None.
///	Return value: None.

private _temp = PG_VAR_CURRENT_PORTAL;
PG_VAR_CURRENT_PORTAL = PG_VAR_OTHER_PORTAL;
PG_VAR_OTHER_PORTAL = _temp;
PG_VAR_ANIM_HANDLE = objNull; // Clear animation handle to prevent conflict

// Force firemode match
private _newMuzzle = "";
if (PG_VAR_CURRENT_PORTAL isEqualTo PG_VAR_ORANGE_PORTAL) then {
	_newMuzzle = "OrangePortal";
} else {
	_newMuzzle = (primaryWeapon player);
};

// Delay muzzle swap slightly so that ArmA's doesn't override ours.
_newMuzzle spawn {
	sleep 0.01;
	private _ammo = player ammo _this; 
	player setAmmo [_this, 0]; 
	player forceWeaponFire [_this, "Single"]; 
	player setAmmo [_this, _ammo];
};