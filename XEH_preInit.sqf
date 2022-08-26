// Copyright 2021 Sysroot & Eisenhorn

// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at

    // http://www.apache.org/licenses/LICENSE-2.0

// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

private _modName = localize "$STR_PGUN_Name_Short";
// ACE medical compatibility check
ASHPD_VAR_ACEMED_ENABLED = isClass (configFile >> "CfgPatches" >> "ace_medical");

/// Controls ///

// Allowed keys for the grab control
ASHPD_VAR_GRAB_KEYS = [
	"fire", "User1", "User2", "User3", "User4", "User5", "User6", "User7", "User8", "User9", "User10",
	"User11", "User12", "User13", "User14", "User15", "User16", "User17", "User18", "User19", "User20"
];

// Allowed keys for the fizzle control
ASHPD_VAR_FIZZLE_KEYS = [
	"deployWeaponAuto", "User1", "User2", "User3", "User4", "User5", "User6", "User7", "User8", "User9", "User10",
	"User11", "User12", "User13", "User14", "User15", "User16", "User17", "User18", "User19", "User20"
];

[
	"ASHPD_VAR_GRAB_KEY",
	"LIST",
	["$STR_PGUN_Grab_Key", "$STR_PGUN_Grab_Key_Desc"],
	[_modName, "$STR_PGUN_Controls"],
	[
		ASHPD_VAR_GRAB_KEYS,
		ASHPD_VAR_GRAB_KEYS apply {actionName _x},
		0
	],
	0,
	{
		removeUserActionEventHandler [ASHPD_VAR_OLD_GRAB_KEY, "Activate", ASHPD_VAR_GRAB_KEY_INDEX];
		ASHPD_VAR_GRAB_KEY_INDEX = addUserActionEventHandler [_this, "Activate", ASHPD_fnc_ToggleGrab];
		ASHPD_VAR_OLD_GRAB_KEY = _this;
	},
	false
] call CBA_fnc_addSetting;

[
	"ASHPD_VAR_FIZZLE_KEY",
	"LIST",
	["$STR_PGUN_Fizzle_Key", "$STR_PGUN_Fizzle_Key_Desc"],
	[_modName, "$STR_PGUN_Controls"],
	[
		ASHPD_VAR_FIZZLE_KEYS,
		ASHPD_VAR_FIZZLE_KEYS apply {actionName _x},
		0
	],
	0,
	{
		removeUserActionEventHandler [ASHPD_VAR_OLD_FIZZLE_KEY, "Activate", ASHPD_VAR_FIZZLE_KEY_INDEX];
		ASHPD_VAR_FIZZLE_KEY_INDEX = addUserActionEventHandler [_this, "Activate", {
			if (ASHPD_VAR_PLAYER_FIZZLE_ENABLED && {(currentWeapon player) isKindOf ["ASHPD_MK_SUS_Base_F", configFile >> "CfgWeapons"]}) then {
				[] spawn ASHPD_fnc_Fizzle;
			};
		}];
		ASHPD_VAR_OLD_FIZZLE_KEY = _this;
	},
	false
] call CBA_fnc_addSetting;

/// Toggles ///

[
	"ASHPD_VAR_LONG_FALL_BOOTS_ENABLED",
	"CHECKBOX",
	["$STR_PGUN_Long_Fall_Boots_Enabled", "$STR_PGUN_Long_Fall_Boots_Enabled_Desc"],
	[_modName, "$STR_PGUN_Toggles"],
	true,
	1,
	{
		// If ACE medical is enabled, make sure we disable fall damage while player is falling
		if (_this && ASHPD_VAR_ACEMED_ENABLED) then {
			ASHPD_VAR_FALL_HANDLE = [] spawn {
				while {true} do {
					if (!isTouchingGround player && {vectorMagnitude velocity player > 0.1}) then {
						player setVariable ["ace_medical_allowDamage", false];
						waitUntil {vectorMagnitude velocity player <= 0.1};
						player setVariable ["ace_medical_allowDamage", true];
					};
					sleep 0.5;
				};
			};
		} else {
			// Terminate fall damage suppression if it's running
			if !(isNil "ASHPD_VAR_FALL_HANDLE") then {
				terminate ASHPD_VAR_FALL_HANDLE;
			};
		};
	},
	false
] call CBA_fnc_addSetting;

[
	"ASHPD_VAR_GRAB_ENABLED",
	"CHECKBOX",
	["$STR_PGUN_Grab_Enabled", "$STR_PGUN_Grab_Enabled_Desc"],
	[_modName, "$STR_PGUN_Toggles"],
	true,
	1,
	{},
	false
] call CBA_fnc_addSetting;

[
	"ASHPD_VAR_FIZZLE_ON_DEATH_ENABLED",
	"CHECKBOX",
	["$STR_PGUN_Fizzle_On_Death_Enabled", "$STR_PGUN_Fizzle_On_Death_Enabled_Desc"],
	[_modName, "$STR_PGUN_Toggles"],
	false,
	1,
	{},
	false
] call CBA_fnc_addSetting;

[
	"ASHPD_VAR_PLAYER_FIZZLE_ENABLED",
	"CHECKBOX",
	["$STR_PGUN_Player_Fizzle_Enabled", "$STR_PGUN_Player_Fizzle_Enabled_Desc"],
	[_modName, "$STR_PGUN_Toggles"],
	true,
	1,
	{},
	false
] call CBA_fnc_addSetting;

[
	"ASHPD_VAR_INFINITE_AMMO_ENABLED",
	"CHECKBOX",
	["$STR_PGUN_Infinite_Ammo_Enabled", "$STR_PGUN_Infinite_Ammo_Enabled_Desc"],
	[_modName, "$STR_PGUN_Toggles"],
	false,
	1,
	{},
	false
] call CBA_fnc_addSetting;

[
	"ASHPD_VAR_BH_ENABLED",
	"CHECKBOX",
	["$STR_PGUN_BlackHole_Enabled", "$STR_PGUN_BlackHole_Enabled_Desc"],
	[_modName, "$STR_PGUN_Toggles"],
	false,
	1,
	{},
	false
] call CBA_fnc_addSetting;

[
	"ASHPD_VAR_PIP_ENABLED",
	"CHECKBOX",
	["$STR_PGUN_PiP_Enabled", "$STR_PGUN_PiP_Enabled_Desc"],
	[_modName, "$STR_PGUN_Toggles"],
	true,
	0,
	{
		if (ASHPD_VAR_PORTALS_LINKED) then {
			if (_this) then {
				[ASHPD_VAR_BLUE_PORTAL, ASHPD_VAR_ORANGE_PORTAL] remoteExecCall ["ASHPD_fnc_LinkPortals", [0, -2] select ASHPD_VAR_IS_DEDI, format ["ASHPD_LINK_%1", clientOwner]];
			} else {
				[ASHPD_VAR_BLUE_PORTAL, ASHPD_VAR_ORANGE_PORTAL] remoteExecCall ["ASHPD_fnc_UnlinkPortals", [0, -2] select ASHPD_VAR_IS_DEDI, format ["ASHPD_LINK_%1", clientOwner]];
			};
		};
	},
	false
] call CBA_fnc_addSetting;

[
	"ASHPD_VAR_CROSSHAIR_ENABLED",
	"CHECKBOX",
	["$STR_PGUN_Crosshair_Enabled", "$STR_PGUN_Crosshair_Enabled_Desc"],
	[_modName, "$STR_PGUN_Toggles"],
	true,
	0,
	{
		[] call ASHPD_fnc_UpdateCrosshair;
	},
	false
] call CBA_fnc_addSetting;

[
	"ASHPD_VAR_POTATO_ENABLED",
	"CHECKBOX",
	["$STR_PGUN_Potato_Enabled", "$STR_PGUN_Potato_Enabled_Desc"],
	[_modName, "$STR_PGUN_Toggles"],
	true,
	0,
	{},
	false
] call CBA_fnc_addSetting;

/// Tolerances ///

[
	"ASHPD_VAR_FLAT_TOLERANCE",
	"SLIDER",
	["$STR_PGUN_Flat_Tolerance", "$STR_PGUN_Flat_Tolerance_Desc"],
	[_modName, "$STR_PGUN_Tolerances"],
	[0, 0.5, 0.25, 2, false],
	1,
	{},
	false
] call CBA_fnc_addSetting;

[
	"ASHPD_VAR_VERTICAL_TOLERANCE",
	"SLIDER",
	["$STR_PGUN_Vertical_Tolerance", "$STR_PGUN_Vertical_Tolerance_Desc"],
	[_modName, "$STR_PGUN_Tolerances"],
	[1, 90, 30, 0, false],
	1,
	{},
	false
] call CBA_fnc_addSetting;

[
	"ASHPD_VAR_MAX_FIT_TRIES",
	"SLIDER",
	["$STR_PGUN_Max_Fit_Tries", "$STR_PGUN_Max_Fit_Tries_Desc"],
	[_modName, "$STR_PGUN_Tolerances"],
	[1, 20, 10, 0, false],
	1,
	{},
	false
] call CBA_fnc_addSetting;

[
	"ASHPD_VAR_MAX_GRAB_MASS",
	"SLIDER",
	["$STR_PGUN_Max_Grab_Mass", "$STR_PGUN_Max_Grab_Mass_Desc"],
	[_modName, "$STR_PGUN_Tolerances"],
	[0, 500, 85, 2, false],
	1,
	{},
	false
] call CBA_fnc_addSetting;

/// Ranges ///

[
	"ASHPD_VAR_MAX_RANGE",
	"SLIDER",
	["$STR_PGUN_Max_Range", "$STR_PGUN_Max_Range_Desc"],
	[_modName, "$STR_PGUN_Ranges"],
	[0, 5000, 500, 2, false],
	1,
	{},
	false
] call CBA_fnc_addSetting;

[
	"ASHPD_VAR_VEHICLE_GRAB_RANGE",
	"SLIDER",
	["$STR_PGUN_Vehicle_Grab_Range", "$STR_PGUN_Vehicle_Grab_Range_Desc"],
	[_modName, "$STR_PGUN_Ranges"],
	[0, 50, 6, 2, false],
	1,
	{},
	false
] call CBA_fnc_addSetting;

[
	"ASHPD_VAR_UNIT_GRAB_RANGE",
	"SLIDER",
	["$STR_PGUN_Unit_Grab_Range", "$STR_PGUN_Unit_Grab_Range_Desc"],
	[_modName, "$STR_PGUN_Ranges"],
	[0, 50, 1.5, 2, false],
	1,
	{},
	false
] call CBA_fnc_addSetting;

[
	"ASHPD_VAR_PROJECTILE_GRAB_RANGE",
	"SLIDER",
	["$STR_PGUN_Projectile_Grab_Range", "$STR_PGUN_Projectile_Grab_Range_Desc"],
	[_modName, "$STR_PGUN_Ranges"],
	[0, 50, 10, 2, false],
	1,
	{},
	false
] call CBA_fnc_addSetting;

[
	"ASHPD_VAR_MAX_GRAB_RANGE",
	"SLIDER",
	["$STR_PGUN_Grab_Range", "$STR_PGUN_Grab_Range_Desc"],
	[_modName, "$STR_PGUN_Ranges"],
	[0, 50, 1.5, 2, false],
	1,
	{},
	false
] call CBA_fnc_addSetting;

[
	"ASHPD_VAR_NUDGE_RANGE",
	"SLIDER",
	["$STR_PGUN_Nudge_Range", "$STR_PGUN_Nudge_Range_Desc"],
	[_modName, "$STR_PGUN_Ranges"],
	[0, 20, 5, 2, false],
	1,
	{},
	false
] call CBA_fnc_addSetting;

/// Misc ///

[
	"ASHPD_VAR_PORTAL_GUN_MODE",
	"LIST",
	["$STR_PGUN_Portal_Gun_Mode", "$STR_PGUN_Portal_Gun_Mode_Desc"],
	[_modName, "$STR_PGUN_Misc"],
	[
		[[true, true], [true, false], [false, true]],
		["$STR_PGUN_Dual", "$STR_PGUN_Blue_Only", "$STR_PGUN_Orange_Only"],
		0
	],
	1,
	{
		_this remoteExecCall ["ASHPD_fnc_InitGun", [0, -2] select ASHPD_VAR_IS_DEDI, "ASHPD_INIT_GUN"];
	},
	false
] call CBA_fnc_addSetting;

[
	"ASHPD_VAR_CROSSHAIR_SCALE",
	"SLIDER",
	["$STR_PGUN_Crosshair_Scale", "$STR_PGUN_Crosshair_Scale_Desc"],
	[_modName, "$STR_PGUN_Misc"],
	[0, 1, 0.25, 2, false],
	0,
	{},
	false
] call CBA_fnc_addSetting;

[
	"ASHPD_VAR_FALL_VELOCITY",
	"SLIDER",
	["$STR_PGUN_Fall_Velocity", "$STR_PGUN_Fall_Velocity_Desc"],
	[_modName, "$STR_PGUN_Misc"],
	[0, 10, 3, 2, false],
	1,
	{},
	false
] call CBA_fnc_addSetting;

[
	"ASHPD_VAR_NUDGE_STRENGTH",
	"SLIDER",
	["$STR_PGUN_Nudge_Strength", "$STR_PGUN_Nudge_Strength_Desc"],
	[_modName, "$STR_PGUN_Misc"],
	[0, 1, 0.04, 2, false],
	1,
	{},
	false
] call CBA_fnc_addSetting;

[
	"ASHPD_VAR_PROJECTILE_TYPES_SETTING",
	"EDITBOX",
	["$STR_PGUN_Projectile_Types", "$STR_PGUN_Projectile_Types_Desc"],
	[_modName, "$STR_PGUN_Misc"],
	"BulletCore, ShellCore, RocketCore, MissileCore, GrenadeCore, BombCore, MineCore, TimeBombCore",
	1,
	{
		ASHPD_VAR_PROJECTILE_TYPES = _this splitString ", ";
	},
	false
] call CBA_fnc_addSetting;