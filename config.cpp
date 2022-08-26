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

class CfgPatches
{
	class ASHPD
	{
		name = "$STR_PGUN_Name_Short";
		author = "Sysroot & Eisenhorn";
		url = "https://github.com/hochladen/PortalGun";
		requiredAddons[] = 
		{ 
		    "cba_ui",
			"cba_xeh",
			"cba_jr",
			"A3_Weapons_F",
			"A3_Weapons_F_Explosives" 
		};
		requiredVersion = 0.1;
		units[] = 
		{ 
		    "item_ASHPD_MK_SUS",
			"item_ASHPD_MK_SUS_P",
			"item_GeneticLifeFormandDiskOperatingSystem",
			"Portal",
			"Weighted_Companion_Cube",
			"Weighted_Storage_Cube",
			"Edge_Less_Safety_Cube",
			"Pernicious_Sponge",
			"ApertureScienceAcousticJoviationDevice",
			"Cylindrical_Baked_Substance",
			"death"
		};
		weapons[] =
		{ 
		    "ASHPD_MK_SUS",
			"ASHPD_MK_SUS_P",
			"GeneticLifeFormandDiskOperatingSystem" 
		};
		ammo[] = 
		{ 
		    "Portal_Ammo",
			"Portal_Base",
			"Cylindrical_Baked_Substance_Ammo" 
		};
		magazines[] = 
		{ 
		    "AS_MBH",
			"Cylindrical_Baked_Substance_Mag" 
		};
		vehicles[] = { "Portal" };
	};
};

class Extended_PreInit_EventHandlers
{
	class ASHPD_Init_Addon_Options
	{
		init = "call compile preprocessFileLineNumbers 'PortalGun\XEH_preInit.sqf'";
	};
};

class CfgEditorSubcategories
{
	class EdCat_Portal
	{
		displayName = "$STR_PGUN_Portal";
	};
};

#include "\PortalGun\configs\CfgFunctions.hpp"
#include "\PortalGun\configs\CfgVFX.hpp"
#include "\PortalGun\configs\CfgAudio.hpp"
#include "\PortalGun\configs\CfgWeapons.hpp"
#include "\PortalGun\configs\CfgVehicles.hpp"
#include "\PortalGun\configs\CfgAmmo.hpp"
#include "\PortalGun\configs\CfgMagazines.hpp"
#include "\PortalGun\configs\CfgLights.hpp"