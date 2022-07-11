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

#ifdef PG_DEBUG
PG_LOG_FUNC("XEH_preInit");
#endif

PG_VAR_MOD_NAME = localize "$STR_PGUN_Name_Short";

/// Scales ///

[
	"PG_VAR_CROSSHAIR_SCALE",
	"SLIDER",
	["$STR_PGUN_Crosshair_Scale", "$STR_PGUN_Crosshair_Scale_Desc"],
	[PG_VAR_MOD_NAME, "$STR_PGUN_Scales"],
	[0, 10, 0.25, 2, false],
	0,
	{},
	false
] call CBA_fnc_addSetting;

/// Ranges ///

[
	"PG_VAR_MAX_RANGE",
	"SLIDER",
	["$STR_PGUN_Max_Range", "$STR_PGUN_Max_Range_Desc"],
	[PG_VAR_MOD_NAME, "$STR_PGUN_Ranges"],
	[0, 5000, 500, 2, false],
	1,
	{},
	false
] call CBA_fnc_addSetting;

[
	"PG_VAR_VEHICLE_GRAB_RANGE",
	"SLIDER",
	["$STR_PGUN_Vehicle_Grab_Range", "$STR_PGUN_Vehicle_Grab_Range_Desc"],
	[PG_VAR_MOD_NAME, "$STR_PGUN_Ranges"],
	[0, 50, 6, 2, false],
	1,
	{},
	false
] call CBA_fnc_addSetting;

[
	"PG_VAR_UNIT_GRAB_RANGE",
	"SLIDER",
	["$STR_PGUN_Unit_Grab_Range", "$STR_PGUN_Unit_Grab_Range_Desc"],
	[PG_VAR_MOD_NAME, "$STR_PGUN_Ranges"],
	[0, 50, 1.5, 2, false],
	1,
	{},
	false
] call CBA_fnc_addSetting;

[
	"PG_VAR_PROJECTILE_GRAB_RANGE",
	"SLIDER",
	["$STR_PGUN_Projectile_Grab_Range", "$STR_PGUN_Projectile_Grab_Range_Desc"],
	[PG_VAR_MOD_NAME, "$STR_PGUN_Ranges"],
	[0, 50, 10, 2, false],
	1,
	{},
	false
] call CBA_fnc_addSetting;

[
	"PG_VAR_MAX_GRAB_RANGE",
	"SLIDER",
	["$STR_PGUN_Grab_Range", "$STR_PGUN_Grab_Range_Desc"],
	[PG_VAR_MOD_NAME, "$STR_PGUN_Ranges"],
	[0, 50, 1.5, 2, false],
	1,
	{},
	false
] call CBA_fnc_addSetting;

[
	"PG_VAR_NUDGE_RANGE",
	"SLIDER",
	["$STR_PGUN_Nudge_Range", "$STR_PGUN_Nudge_Range_Desc"],
	[PG_VAR_MOD_NAME, "$STR_PGUN_Ranges"],
	[0, 20, 5, 2, false],
	1,
	{},
	false
] call CBA_fnc_addSetting;

/// Tolerances ///

[
	"PG_VAR_FLAT_TOLERANCE",
	"SLIDER",
	["$STR_PGUN_Flat_Tolerance", "$STR_PGUN_Flat_Tolerance_Desc"],
	[PG_VAR_MOD_NAME, "$STR_PGUN_Tolerances"],
	[0, 0.5, 0.05, 2, false],
	1,
	{},
	false
] call CBA_fnc_addSetting;

[
	"PG_VAR_VERTICAL_TOLERANCE",
	"SLIDER",
	["$STR_PGUN_Vertical_Tolerance", "$STR_PGUN_Vertical_Tolerance_Desc"],
	[PG_VAR_MOD_NAME, "$STR_PGUN_Tolerances"],
	[1, 90, 45, 0, false],
	1,
	{},
	false
] call CBA_fnc_addSetting;

[
	"PG_VAR_MAX_FIT_TRIES",
	"SLIDER",
	["$STR_PGUN_Max_Fit_Tries", "$STR_PGUN_Max_Fit_Tries_Desc"],
	[PG_VAR_MOD_NAME, "$STR_PGUN_Tolerances"],
	[1, 20, 10, 0, false],
	1,
	{},
	false
] call CBA_fnc_addSetting;

[
	"PG_VAR_MAX_GRAB_MASS",
	"SLIDER",
	["$STR_PGUN_Max_Grab_Mass", "$STR_PGUN_Max_Grab_Mass_Desc"],
	[PG_VAR_MOD_NAME, "$STR_PGUN_Tolerances"],
	[0, 500, 85, 2, false],
	1,
	{},
	false
] call CBA_fnc_addSetting;

/// Toggles ///

[
	"PG_VAR_GRAB_ENABLED",
	"CHECKBOX",
	["$STR_PGUN_Grab_Enabled", "$STR_PGUN_Grab_Enabled_Desc"],
	[PG_VAR_MOD_NAME, "$STR_PGUN_Toggles"],
	true,
	1,
	{},
	false
] call CBA_fnc_addSetting;

[
	"PG_VAR_FIZZLE_ON_DEATH_ENABLED",
	"CHECKBOX",
	["$STR_PGUN_Fizzle_On_Death_Enabled", "$STR_PGUN_Fizzle_On_Death_Enabled_Desc"],
	[PG_VAR_MOD_NAME, "$STR_PGUN_Toggles"],
	false,
	1,
	{},
	false
] call CBA_fnc_addSetting;

[
	"PG_VAR_PLAYER_FIZZLE_ENABLED",
	"CHECKBOX",
	["$STR_PGUN_Player_Fizzle_Enabled", "$STR_PGUN_Player_Fizzle_Enabled_Desc"],
	[PG_VAR_MOD_NAME, "$STR_PGUN_Toggles"],
	true,
	1,
	{},
	false
] call CBA_fnc_addSetting;

[
	"PG_VAR_INFINITE_AMMO_ENABLED",
	"CHECKBOX",
	["$STR_PGUN_Infinite_Ammo_Enabled", "$STR_PGUN_Infinite_Ammo_Enabled_Desc"],
	[PG_VAR_MOD_NAME, "$STR_PGUN_Toggles"],
	false,
	1,
	{},
	false
] call CBA_fnc_addSetting;

[
	"PG_VAR_BH_ENABLED",
	"CHECKBOX",
	["$STR_PGUN_BlackHole_Enabled", "$STR_PGUN_BlackHole_Enabled_Desc"],
	[PG_VAR_MOD_NAME, "$STR_PGUN_Toggles"],
	false,
	1,
	{},
	false
] call CBA_fnc_addSetting;

[
	"PG_VAR_PIP_ENABLED",
	"CHECKBOX",
	["$STR_PGUN_PiP_Enabled", "$STR_PGUN_PiP_Enabled_Desc"],
	[PG_VAR_MOD_NAME, "$STR_PGUN_Toggles"],
	true,
	0,
	{
		if (PG_VAR_PORTALS_LINKED) then {
			if (_this) then {
				[PG_VAR_BLUE_PORTAL, PG_VAR_ORANGE_PORTAL] remoteExecCall ["PG_fnc_LinkPortals", 0, true];
			} else {
				[PG_VAR_BLUE_PORTAL, PG_VAR_ORANGE_PORTAL] remoteExecCall ["PG_fnc_UnlinkPortals", 0, true];
			};
		};
	},
	false
] call CBA_fnc_addSetting;

[
	"PG_VAR_CROSSHAIR_ENABLED",
	"CHECKBOX",
	["$STR_PGUN_Crosshair_Enabled", "$STR_PGUN_Crosshair_Enabled_Desc"],
	[PG_VAR_MOD_NAME, "$STR_PGUN_Toggles"],
	true,
	0,
	{},
	false
] call CBA_fnc_addSetting;

[
	"PG_VAR_POTATO_ENABLED",
	"CHECKBOX",
	["$STR_PGUN_Potato_Enabled", "$STR_PGUN_Potato_Enabled_Desc"],
	[PG_VAR_MOD_NAME, "$STR_PGUN_Toggles"],
	true,
	0,
	{},
	false
] call CBA_fnc_addSetting;

/// Controls ///

// Allowed keys for the grab control
PG_VAR_GRAB_KEYS = [
	"fire", "User1", "User2", "User3", "User4", "User5", "User6", "User7", "User8", "User9", "User10",
	"User11", "User12", "User13", "User14", "User15", "User16", "User17", "User18", "User19", "User20"
];

// Allowed keys for the fizzle control
PG_VAR_FIZZLE_KEYS = [
	"deployWeaponAuto", "User1", "User2", "User3", "User4", "User5", "User6", "User7", "User8", "User9", "User10",
	"User11", "User12", "User13", "User14", "User15", "User16", "User17", "User18", "User19", "User20"
];

[
	"PG_VAR_GRAB_KEY",
	"LIST",
	["$STR_PGUN_Grab_Key", "$STR_PGUN_Grab_Key_Desc"],
	[PG_VAR_MOD_NAME, "$STR_PGUN_Controls"],
	[
		PG_VAR_GRAB_KEYS,
		PG_VAR_GRAB_KEYS apply {actionName _x},
		0
	],
	0,
	{
		removeUserActionEventHandler [PG_VAR_OLD_GRAB_KEY, "Activate", PG_VAR_GRAB_KEY_INDEX];
		PG_VAR_GRAB_KEY_INDEX = addUserActionEventHandler [_this, "Activate", PG_fnc_TryGrab];
		PG_VAR_OLD_GRAB_KEY = _this;
	},
	false
] call CBA_fnc_addSetting;

[
	"PG_VAR_FIZZLE_KEY",
	"LIST",
	["$STR_PGUN_Fizzle_Key", "$STR_PGUN_Fizzle_Key_Desc"],
	[PG_VAR_MOD_NAME, "$STR_PGUN_Controls"],
	[
		PG_VAR_FIZZLE_KEYS,
		PG_VAR_FIZZLE_KEYS apply {actionName _x},
		0
	],
	0,
	{
		removeUserActionEventHandler [PG_VAR_OLD_FIZZLE_KEY, "Activate", PG_VAR_FIZZLE_KEY_INDEX];
		PG_VAR_FIZZLE_KEY_INDEX = addUserActionEventHandler [_this, "Activate", {
			if (PG_VAR_PLAYER_FIZZLE_ENABLED && {(currentWeapon player) isKindOf ["ASHPD_MK_SUS_Base_F", configFile >> "CfgWeapons"]}) then {
				[] call PG_fnc_Fizzle;
			};
		}];
		PG_VAR_OLD_FIZZLE_KEY = _this;
	},
	false
] call CBA_fnc_addSetting;

/// Misc ///

[
	"PG_VAR_FALL_VELOCITY",
	"SLIDER",
	["$STR_PGUN_Fall_Velocity", "$STR_PGUN_Fall_Velocity_Desc"],
	[PG_VAR_MOD_NAME, "$STR_PGUN_Misc"],
	[0, 10, 3, 2, false],
	1,
	{},
	false
] call CBA_fnc_addSetting;

[
	"PG_VAR_NUDGE_STRENGTH",
	"SLIDER",
	["$STR_PGUN_Nudge_Strength", "$STR_PGUN_Nudge_Strength_Desc"],
	[PG_VAR_MOD_NAME, "$STR_PGUN_Misc"],
	[0, 1, 0.04, 2, false],
	1,
	{},
	false
] call CBA_fnc_addSetting;

[
	"PG_VAR_PROJECTILE_TYPES_SETTING",
	"EDITBOX",
	["$STR_PGUN_Projectile_Types", "$STR_PGUN_Projectile_Types_Desc"],
	[PG_VAR_MOD_NAME, "$STR_PGUN_Misc"],
	"BulletCore, ShellCore, RocketCore, MissileCore, GrenadeCore, BombCore, MineCore, TimeBombCore",
	1,
	{
		PG_VAR_PROJECTILE_TYPES = _this splitString ", ";
	},
	false
] call CBA_fnc_addSetting;

[
	"PG_VAR_PORTAL_GUN_MODE",
	"LIST",
	["$STR_PGUN_Portal_Gun_Mode", "$STR_PGUN_Portal_Gun_Mode_Desc"],
	[PG_VAR_MOD_NAME, "$STR_PGUN_Misc"],
	[
		[[true, true], [true, false], [false, true]],
		["$STR_PGUN_Dual", "$STR_PGUN_Blue_Only", "$STR_PGUN_Orange_Only"],
		0
	],
	1,
	{
		_this remoteExecCall ["PG_fnc_InitPortals"];
	},
	false
] call CBA_fnc_addSetting;