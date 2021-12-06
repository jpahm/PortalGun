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

class CfgPatches
{
	class Aperture_Science_Handheld_Portal_Device
	{
		requiredAddons[]=
		{
			"cba_ui",
            "cba_xeh",
            "cba_jr",
			"SUS",
			"A3_Weapons_F"
		};
		requiredVersion=0.1;
		units[]=
		{
			"item_ASHPD_MK_SUS",
			"item_ASHPD_MK_SUS_P",
			"item_GeneticLifeFormandDiskOperatingSystem"
		};
		weapons[]=
		{
			"ASHPD_MK_SUS",
			"ASHPD_MK_SUS_P",
			"GeneticLifeFormandDiskOperatingSystem"
		};
		ammo[]=
		{
			"Portal_Ammo"
		};
		magazines[]=
		{
			"AS_MBH"
		};
		vehicles[]=
		{
			"Portal"
		};
	};
};
class CfgFunctions
{
	class PG
	{
		class Aperture_Science_Modular_Computational_Component_Storage
		{
			tag="PG";
			file="\PortalGun\Aperture_Science_Modular_Computational_Component_Storage";
			class AnimatePortal {};
			class ASHPD {};
			class DetectObjects {};
			class DoBoundsCheck {};
			class DoCamFollow {};
			class DoCamIllusion {};
			class DoTeleport {};
			class DrawCrosshair {};
			class FixArsenalBug {};
			class Fizzle {};
			class GetSurfaceUpVec {};
			class HandleWeaponSwitch {};
			class InitASHPD
			{
				postInit=1;
			};
			class InitDisconnect {};
			class InitPortals {};
			class LinkPortals {};
			class PlaySound {};
			class RefreshPiP {};
			class RemoteUpdate {};
			class RestrictVector {};
			class SpeakPotato {};
			class SwapPortals {};
			class TryGrab {};
			class TrySpawnPortal {};
			class UnlinkPortals {};
			class UpdateCrosshair {};
			class UpdatePortals {};
		};
	};
};

class Extended_PreInit_EventHandlers {
    class PG_Init_Addon_Options {
        init = "call compile preprocessFileLineNumbers 'PortalGun\XEH_preInit.sqf'";
    };
};

class Mode_SemiAuto;
class Mode_Burst;
class Mode_FullAuto;
class SlotInfo;
class ItemCore;
class PointerSlot;
class InventoryFlashLightItem_Base_F;
class CfgWeapons
{
	class Default;
	class acc_pointer_IR;
	class GeneticLifeFormandDiskOperatingSystem: acc_pointer_IR
	{
		scope=2;
		displayName="GLaDOS";
		model="";
		author="";
		picture="";
		UiPicture="";
		class ItemInfo: InventoryFlashLightItem_Base_F
		{
			mass=0.002;
			class Pointer
			{
			};
		};
	};
	class GrenadeLauncher;
	class Rifle;
	class Portal_Base_F: Rifle
	{
		scope=0;
		discreteDistance[]={0,1,2,3};
		discreteDistanceInitIndex=0;
		weaponInfoType="RscWeaponZeroing";
		recoil="recoil_default";
		deployedPivot="bipod";
		class GunParticles
		{
			class FirstEffect
			{
				effectName="PgunFired";
				positionName="Usti hlavne";
				directionName="Konec hlavne";
			};
		};
	};
	class ASHPD_MK_SUS_Base_F: Portal_Base_F
	{
		author="Eisenhorn/Sysroot";
		_generalMacro="ASHPD_MK_SUS_Base_F";
		visibleFire = 50;
		visibleFireTime = 12;
		audibleFire = 1000;
		audibleFireTime = 24;
		scope=0;
		magazines[]=
		{
			"AS_MBH"
		};
		magazineWell[]=
		{
			"ASHPD_MBHCU"
		};
		displayName="$STR_PGUN_Primary_Portal";
		model="PortalGun\Aperture_Science_Three_Dimensional_Isomorphic_Volume_Chamber\ApertureScienceHandheldPortalDevice.p3d";
		picture="\A3\weapons_F\Rifles\MX\data\UI\gear_mx_cqc_X_CA.paa";
		UiPicture="\A3\weapons_f\data\UI\icon_regular_CA.paa";
		muzzles[]=
		{
			"this"
		};
		handAnim[]=
		{
			"OFP2_ManSkeleton",
			"\A3\Weapons_F\Rifles\MX\data\Anim\MX_cqc.rtm"
		};
		reloadAction="Disable_Gesture";
		recoil="recoil_gm6";
		weaponInfoType="RscWeaponEmpty";
		cursor="EmptyCursor";
		initSpeed=299792458;
		caseless[]={"",1,1,1};
		soundBullet[]=
		{
			"caseless",
			1
		};
		class WeaponSlotsInfo
		{
			mass=100;
		};
        maxRecoilSway = 0.0125;
        swayDecaySpeed = 1.25;
		inertia=0.40000001;
		aimTransitionSpeed=1.2;
		dexterity=1.6;
		maxZeroing=800;
		class ItemInfo
		{
			priority=1;
		};
		modes[]={"Blue","Orange"};
		descriptionShort="Portal_Device";
		class Blue: Mode_SemiAuto
		{
			reloadTime=0.25;
			dispersion=0;
			minRange=2;
			minRangeProbab=0.30000001;
			midRange=150;
			midRangeProbab=0.69999999;
			maxRange=350;
			maxRangeProbab=0.1;
            displayname = "$STR_PGUN_Primary_Portal";
			sounds[]={"StandardSound"};
			class BaseSoundModeType
			{
				closure1[]={"A3\Sounds_F\arsenal\weapons\UGL\Closure_UGL",
					1,1,10};
				soundClosure[]={"closure1",1};
			};
			class StandardSound: BaseSoundModeType
			{
				begin1[]=
				{
				"\PortalGun\Aperture_Science_Long_Band_Frequency_Air_Disturbance_Generator_Container\gun_fire_Blue.ogg",
					0.70794576,1,200
				};
				begin2[]=
				{
				"\PortalGun\Aperture_Science_Long_Band_Frequency_Air_Disturbance_Generator_Container\gun_fire_Blue.ogg",
					0.70794576,1,200
				};
				soundBegin[]=
				{
				    "begin1",0.5,
					"begin2",0.5
				};
			};
		};
		class Orange: Mode_SemiAuto
		{
			reloadTime=0.25;
			dispersion=0;
			minRange=2;
			minRangeProbab=0.30000001;
			midRange=150;
			midRangeProbab=0.69999999;
			maxRange=350;
			maxRangeProbab=0.1;
            displayname = "$STR_PGUN_Secondary_Portal";
			sounds[]={"StandardSound"};
			class BaseSoundModeType
			{
				closure1[]={"A3\Sounds_F\arsenal\weapons\UGL\Closure_UGL",
					1,1,10};
				soundClosure[]={"closure1",1};
			};
			class StandardSound: BaseSoundModeType
			{
				begin1[]=
				{
				"\PortalGun\Aperture_Science_Long_Band_Frequency_Air_Disturbance_Generator_Container\gun_fire_red.ogg",
					0.70794576,1,200
				};
				begin2[]=
				{
				"\PortalGun\Aperture_Science_Long_Band_Frequency_Air_Disturbance_Generator_Container\gun_fire_red.ogg",
					0.70794576,1,200
				};
				soundBegin[]=
				{
				    "begin1",0.5,
					"begin2",0.5
				};
			};
		};
		class single_medium_optics1: Blue
		{
			showToPlayer=0;
			reloadTime=0.25;
			dispersion=0;
			minRange=2;
			minRangeProbab=0.2;
			midRange=350;
			midRangeProbab=0.69999999;
			maxRange=500;
			maxRangeProbab=0.30000001;
			aiRateOfFire=5;
			aiRateOfFireDistance=500;
		};
		class single_medium_optics2: single_medium_optics1
		{
			showToPlayer=0;
			reloadTime=0.25;
			dispersion=0;
			requiredOpticType=2;
			minRange=100;
			minRangeProbab=0.1;
			midRange=400;
			midRangeProbab=0.60000002;
			maxRange=700;
			maxRangeProbab=0.050000001;
			aiRateOfFire=7;
			aiRateOfFireDistance=700;
		};
		aiDispersionCoefY=6;
		aiDispersionCoefX=4;
	};
	class ASHPD_MK_SUS: ASHPD_MK_SUS_Base_F
	{
		author="Sysroot/Eisenhorn";
		baseWeapon="ASHPD_MK_SUS";
		_generalMacro="ASHPD_MK_SUS";
		scope=2;
		scopeCurator=2;
		scopeArsenal=2;
		model="PortalGun\Aperture_Science_Three_Dimensional_Isomorphic_Volume_Chamber\ApertureScienceHandheldPortalDevice.p3d";
		displayName="$STR_PGUN_Name_Long";
		changeFiremodeSound[]=
		{
			"A3\sounds_f\weapons\closure\firemode_changer_2",
			0.55118901,
			1,
			5
		};
		picture="\PortalGun\ui\Data\weapon-icon.paa";
		//UiPicture="PortalGun\ui\Data\weapon-icon.paa";
		descriptionShort="$STR_PGUN_Description";
		class WeaponSlotsInfo: WeaponSlotsInfo
		{
			mass=100;
		};
		class ItemInfo
		{
			priority=1;
		};
	};
	class ASHPD_MK_SUS_P: ASHPD_MK_SUS_Base_F
	{
		author="Sysroot/Eisenhorn";
		baseWeapon="ASHPD_MK_SUS_P";
		_generalMacro="ASHPD_MK_SUS_P";
		scope=2;
		scopeCurator=2;
		scopeArsenal=2;
		model="PortalGun\Aperture_Science_Three_Dimensional_Isomorphic_Volume_Chamber\ApertureScienceHandheldPortalDevicePotato.p3d";
		displayName="$STR_PGUN_Name_P_Long";
		changeFiremodeSound[]=
		{
			"A3\sounds_f\weapons\closure\firemode_changer_2",
			0.55118901,
			1,
			5
		};
		picture="\PortalGun\ui\Data\weapon-icon.paa";
		//UiPicture="PortalGun\ui\Data\weapon-icon.paa";
		descriptionShort="$STR_PGUN_P_Description";
		class WeaponSlotsInfo: WeaponSlotsInfo
		{
			mass=100;
			class PointerSlot
			{
				compatibleItems[]=
				{
					"GeneticLifeFormandDiskOperatingSystem"
				};
			};
		};
		class ItemInfo
		{
			priority=1;
		};
	};
	class Put: Default
	{
		muzzles[]=
		{
			"Cylindrical_Baked_Substance_Muzzle"
		};
		displayName="$STR_A3_CfgWeapons_Put0";
		class PutMuzzle;
		class Cylindrical_Baked_Substance_Muzzle: PutMuzzle
		{
			autoreload=0;
			displayName="$STR_PGUN_Cake";
			magazines[]=
			{
				"Cylindrical_Baked_Substance_Mag"
			};
			enableAttack=1;
			showToPlayer=0;
		};
	};
};
class CfgEditorSubcategories
{
	class EdCat_Portal
	{
		displayName = "$STR_PGUN_Portal";
	};
};
class CfgVehicles
{
	class Weapon_Base_F;
	class Item_Base_F;
	class item_GeneticLifeFormandDiskOperatingSystem: Item_Base_F
	{
		scope=0;
		scopeCurator=0;
		author="Eisenhorn/Sysroot";
		displayName="PotatOS";
		vehicleClass="WeaponAccessories";
		editorCategory="EdCat_WeaponAttachments";
		editorSubcategory="EdSubcat_SideSlot";
		model="\A3\Weapons_f\dummyweapon.p3d";
		class TransportItems
		{
			class PotatOS
			{
				name="PotatOS";
				count=1;
			};
		};
	};
	class item_ASHPD_MK_SUS: Weapon_Base_F
	{
		class SimpleObject
		{
			eden=1;
		};
		scope=2;
		scopeCurator=2;
		displayName="$STR_PGUN_Name_Long";
		author="Eisenhorn/Sysroot";
		editorCategory="EdCat_Weapons";
		class TransportWeapons
		{
			class ASHPD_MK_SUS
			{
				weapon="ASHPD_MK_SUS";
				count=1;
			};
		};
		class TransportMagazines
		{
			class AS_MBH
			{
				magazine="AS_MBH";
				count=1;
			};
		};
	};
	class item_ASHPD_MK_SUS_P: Weapon_Base_F
	{
		class SimpleObject
		{
			eden=1;
		};
		scope=2;
		scopeCurator=2;
		displayName="$STR_PGUN_Name_P_Long";
		author="Eisenhorn/Sysroot";
		editorCategory="EdCat_Weapons";
		class TransportWeapons
		{
			class ASHPD_MK_SUS_P
			{
				weapon="ASHPD_MK_SUS_P";
				count=1;
			};
		};
		class TransportMagazines
		{
			class AS_MBH
			{
				magazine="AS_MBH";
				count=1;
			};
		};
	};
    class NonStrategic;
	class PortalBeams_Base: NonStrategic
	{
		scope=0;
		scopeCurator=0;
		model="PortalGun\Aperture_Science_Trusted_Third_Party_Vendors\PortalBeams.p3d";
		armor=15;
		icon="\PortalGun\ui\Data\Portal_Editor_Icon.paa";
		destrType="DestructNo";
		editorCategory="EdCat_Things";
		editorSubcategory="EdCat_Portal";
		accuracy=1000;
		nameSound="obj_flag";
		class DestructionEffects {};
		class Attributes {};
		hiddenselections[]=
		{
			"bottomfaceg",
			"bottomfacet",
			"bottomfacer",
			"bottomfacel",
			"frontfaceg",
			"frontfacet",
			"frontfacer",
			"frontfacel",
			"lightningbottomt",
			"lightningbottomr",
			"lightningbottoml",
			"lightningtopt",
			"lightningtopr",
			"lightningtopl"
		};
	};
	class PortalBeams: PortalBeams_Base
	{
		author="Sysroot/Eisenhorn";
		class SimpleObject
		{
			eden=1;
			animate[]={};
			hide[]={};
			verticalOffset=1.2;
			verticalOffsetWorld=0;
			init="''";
		};
		editorPreview="";
		_generalMacro="PortalBeams";
		scope=1;
		scopeCurator=0;
		displayName="PortalBeams";
		hiddenselectionstextures[]=
		{
			"PortalGun\Aperture_Science_Woof_Containment_Vessel\beamtip.paa",
			"PortalGun\Aperture_Science_Woof_Containment_Vessel\beamtip.paa",
			"PortalGun\Aperture_Science_Woof_Containment_Vessel\beamtip.paa",
			"PortalGun\Aperture_Science_Woof_Containment_Vessel\beamtip.paa",
			"PortalGun\Aperture_Science_Woof_Containment_Vessel\beamtip.paa",
			"PortalGun\Aperture_Science_Woof_Containment_Vessel\beamtip.paa",
			"PortalGun\Aperture_Science_Woof_Containment_Vessel\beamtip.paa",
			"PortalGun\Aperture_Science_Woof_Containment_Vessel\beamtip.paa",
			"PortalGun\Aperture_Science_Woof_Containment_Vessel\beamtemp.paa",
			"PortalGun\Aperture_Science_Woof_Containment_Vessel\beamtemp.paa",
			"PortalGun\Aperture_Science_Woof_Containment_Vessel\beamtemp.paa",
			"PortalGun\Aperture_Science_Woof_Containment_Vessel\beamtemp.paa",
			"PortalGun\Aperture_Science_Woof_Containment_Vessel\beamtemp.paa",
			"PortalGun\Aperture_Science_Woof_Containment_Vessel\beamtemp.paa"
		};
		class UVAnimations 
		{
			class Gun_Lightning_Animation_Base
			{
				type			= translation;
				source			= Gun_Lightning_Source;
				sourceAddress	= loop;
				section			= lightningbottomt;
				minValue		= 0;
				maxValue		= 1;
				offset0[]		= {0,0};
				offset1[]		= {0,1};
			};
			
			class Gun_Lightning_Animation_BT : Gun_Lightning_Animation_Base
			{
				section			= lightningbottomt;
			};
			class Gun_Lightning_Animation_BR : Gun_Lightning_Animation_Base
			{
				section			= lightningbottomr;
			};
			class Gun_Lightning_Animation_BL : Gun_Lightning_Animation_Base
			{
				section			= lightningbottoml;
			};
			class Gun_Lightning_Animation_TT : Gun_Lightning_Animation_Base
			{
				section			= lightningtopt;
			};
			class Gun_Lightning_Animation_TR : Gun_Lightning_Animation_Base
			{
				section			= lightningtopr;
			};
			class Gun_Lightning_Animation_TL : Gun_Lightning_Animation_Base
			{
				section			= lightningtopl;
			};
			
			class Gun_Lightning_Ball_Animation_Base
			{
				type			= rotate;
				source			= Gun_Lightning_Ball_Source;
				sourceAddress	= loop;
				section 		= bottomfaceg;
				minValue		= 0;
				maxValue		= 1;
				// [x,y] - coordinates defining center of rotation
				center[]		= { 0.5, 0.5 };
				// angles are in radians just like in model.cfg
				angle0			= -0;
				angle1			= rad +360; // rotate by 360 degrees
			};
			
			class Gun_Lightning_Ball_Animation_BG : Gun_Lightning_Ball_Animation_Base
			{
				section			= bottomfaceg;
			};
			class Gun_Lightning_Ball_Animation_BT : Gun_Lightning_Ball_Animation_Base
			{
				section			= bottomfacet;
			};
			class Gun_Lightning_Ball_Animation_BR : Gun_Lightning_Ball_Animation_Base
			{
				section			= bottomfacer;
			};
			class Gun_Lightning_Ball_Animation_BL : Gun_Lightning_Ball_Animation_Base
			{
				section			= bottomfacel;
			};
			class Gun_Lightning_Ball_Animation_TG : Gun_Lightning_Ball_Animation_Base
			{
				section			= frontfaceg;
			};
			class Gun_Lightning_Ball_Animation_TT : Gun_Lightning_Ball_Animation_Base
			{
				section			= frontfacet;
			};
			class Gun_Lightning_Ball_Animation_TR : Gun_Lightning_Ball_Animation_Base
			{
				section			= frontfacer;
			};
			class Gun_Lightning_Ball_Animation_TL : Gun_Lightning_Ball_Animation_Base
			{
				section			= frontfacel;
			};
		};
		class AnimationSources
		{
			class Gun_Lightning_Source
			{
				source			= user;
				initPhase		= 0;
				animPeriod		= 1;
			};
			class Gun_Lightning_Ball_Source
			{
				source			= user;
				initPhase		= 0;
				animPeriod		= 1;
			};
		};
	};
	class Portal_Base: NonStrategic
	{
		scope=0;
		scopeCurator=0;
		model="PortalGun\Aperture_Science_Three_Dimensional_Isomorphic_Volume_Chamber\portal.p3d";
		armor=15;
		icon="\PortalGun\ui\Data\Portal_Editor_Icon.paa";
		destrType="DestructNo";
		editorCategory="EdCat_Things";
		editorSubcategory="EdCat_Portal";
		accuracy=1000;
		nameSound="obj_flag";
		class DestructionEffects {};
		class Attributes {};
		hiddenselections[]=
		{
			"portaledge",
			"portal"
		};
	};
	class Portal: Portal_Base
	{
		author="Sysroot/Eisenhorn";
		class SimpleObject
		{
			eden=1;
			animate[]={};
			hide[]={};
			verticalOffset=1.2;
			verticalOffsetWorld=0;
			init="''";
		};
		editorPreview="";
		_generalMacro="Portal";
		scope=2;
		scopeCurator=2;
		displayName="$STR_PGUN_Portal";
		hiddenselectionstextures[]=
		{
			"#(rgb,8,8,3)color(0,0,0,0.5)",
			"#(rgb,8,8,3)color(0,0,0,1)",
		};
		class UVAnimations
		{
			class Portal_Flames_Animation
			{
					type			= translation;
					source			= Portal_Flames_Source;
					sourceAddress	= loop;
					section			= portaledge;
					minValue		= 0;
					maxValue		= 1;
					offset0[]		= {0,0};
					offset1[]		= {0,1};
			};
			class Portal_Noise_Animation
			{
				type			= rotate;
				source			= Portal_Noise_Source;
				sourceAddress	= loop;
				section 		= portal;
				minValue		= 0;
				maxValue		= 1;
				// [x,y] - coordinates defining center of rotation
				center[]		= { 0.5, 0.5 };
				// angles are in radians just like in model.cfg
				angle0			= -0;
				angle1			= rad +360; // rotate by 360 degrees
			};
		};
		class AnimationSources
		{
			class Portal_Flames_Source
			{
				source			= user;
				initPhase		= 0;
				animPeriod		= 20;
			};
			class Portal_Noise_Source
			{
				source			= user;
				initPhase		= 0;
				animPeriod		= 250;
			};
		};
	};
	
	class ThingX;
	
	class PortalAmbientSource : ThingX
	{
		scope=0;
		sound="PortalAmbient"; // reference to CfgSFX class
	};
	
	class GunHoldSource : ThingX
	{
		scope=0;
		sound="GunHoldLoop";
	};
	class Weighted_Companion_Cube_Base: ThingX
	{
		scope=0;
		scopeCurator=0;
		class SimpleObject
		{
			eden=1;
			animate[]={};
			hide[]={};
			verticalOffset=0.5;
			verticalOffsetWorld=0;
			init="''";
		};
		model="PortalGun\Esteemed Confidant Euclidean Trigonal Trapezohedron\Weighted_Companion_Cube.p3d";
		hiddenselections[]=
		{
		   "Weighted_Companion_Cube",
		   "The_Cube_Loves_You"
		};
		armor=200;
		icon="\PortalGun\ui\Data\Portal_Editor_Icon.paa";
		destrType="DestructNo";
		editorCategory="EdCat_Things";
		editorSubcategory="EdCat_Portal";
		accuracy=1000;
		nameSound="obj_flag";
		class DestructionEffects {};
		class Attributes {};
	};
	class Weighted_Companion_Cube: Weighted_Companion_Cube_Base
    {
        author="Sysroot/Eisenhorn";
        editorPreview="";
        _generalMacro="Weighted Companion Cube";
        scope=2;
        scopeCurator=2;
        displayName="$STR_PGUN_Companion_Cube";
        hiddenselections[]=
        {
           "Weighted_Companion_Cube",
           "The_Cube_Loves_You"
        };
        hiddenSelectionsMaterials[]=
        {
            "PortalGun\Esteemed Confidant Euclidean Trigonal Trapezohedron\ApertureScienceWeightedCompanionCube.rvmat",
            "PortalGun\Esteemed Confidant Euclidean Trigonal Trapezohedron\TheCubeLovesYou.rvmat"        
        };
        hiddenSelectionsTextures[]=
        {
            "PortalGun\Esteemed Confidant Euclidean Trigonal Trapezohedron\WCC2_co.paa",
            "PortalGun\Esteemed Confidant Euclidean Trigonal Trapezohedron\WCC2_co.paa"        
        };
    };
	class Weighted_Storage_Cube: Weighted_Companion_Cube_Base
	{
		author="Sysroot/Eisenhorn";
		editorPreview="";
		_generalMacro="Weighted Storage Cube";
		scope=2;
		scopeCurator=2;
		displayName="$STR_PGUN_Storage_Cube";
		hiddenselections[]=
		{
		   "Weighted_Companion_Cube",
		   "The_Cube_Loves_You"
		};
		hiddenSelectionsMaterials[]=
		{
			"PortalGun\Esteemed Confidant Euclidean Trigonal Trapezohedron\ApertureScienceWeightedCompanionCube.rvmat",
			"PortalGun\Esteemed Confidant Euclidean Trigonal Trapezohedron\TheCubeDoesntLoveYou.rvmat"		
		};
		hiddenSelectionsTextures[]=
		{
			"PortalGun\Esteemed Confidant Euclidean Trigonal Trapezohedron\metal_box.paa",
			"PortalGun\Esteemed Confidant Euclidean Trigonal Trapezohedron\metal_box.paa"		
		};
	};
	class Edgeless_Safety_Cube_Base: ThingX
	{
		scope=0;
		scopeCurator=0;
		class SimpleObject
		{
			eden=1;
			animate[]={};
			hide[]={};
			verticalOffset=0.5;
			verticalOffsetWorld=0;
			init="''";
		};
		model="PortalGun\Esteemed Confidant Euclidean Trigonal Trapezohedron\Edgeless_Safety_Cube.p3d";
		hiddenselections[]=
		{
			"TheSphereCantTalk",
			"TheSphereDoesntLoveYou"
		};
		armor=200;
		icon="\PortalGun\ui\Data\Portal_Editor_Icon.paa";
		destrType="DestructNo";
		editorCategory="EdCat_Things";
		editorSubcategory="EdCat_Portal";
		accuracy=1000;
		nameSound="obj_flag";
		class DestructionEffects {};
		class Attributes {};
	};
	class Edgeless_Safety_Cube: Edgeless_Safety_Cube_Base
	{
		author="Sysroot/Eisenhorn";
		editorPreview="";
		_generalMacro="Edge Less Safety Cube";
		scope=2;
		scopeCurator=2;
		displayName="$STR_PGUN_Edgeless_Cube";
		hiddenselections[]=
		{
		   "Weighted_Companion_Cube",
		   "The_Cube_Loves_You"
		};
		hiddenSelectionsMaterials[]=
		{
			"portalgun\esteemed confidant euclidean trigonal trapezohedron\thespheredoesntloveyou.rvmat",
			"portalgun\esteemed confidant euclidean trigonal trapezohedron\thespherestilldoesntloveyou.rvmat"		
		};
		hiddenSelectionsTextures[]=
		{
			"PortalGun\Esteemed Confidant Euclidean Trigonal Trapezohedron\MP_ball_1.paa",
			"PortalGun\Esteemed Confidant Euclidean Trigonal Trapezohedron\MP_ball_1.paa"		
		};
	};
	class Pernicious_Sponge_Base: ThingX
	{
		scope=0;
		scopeCurator=0;
		class SimpleObject
		{
			eden=1;
			animate[]={};
			hide[]={};
			verticalOffset=0.5;
			verticalOffsetWorld=0;
			init="''";
		};
		model="PortalGun\Celebratory_Mendacious_Moist_Consolidated_Sustenance\falsehood.p3d";
		hiddenselections[]=
		{
			"Deception"
		};
		armor=200;
		icon="\PortalGun\ui\Data\Portal_Editor_Icon.paa";
		destrType="DestructNo";
		editorCategory="EdCat_Things";
		editorSubcategory="EdCat_Portal";
		accuracy=1000;
		nameSound="obj_flag";
		init="";
		class DestructionEffects {};
		class Attributes {};
	};
	class Pernicious_Sponge: Pernicious_Sponge_Base
	{
		author="Sysroot/Eisenhorn";
		editorPreview="";
		_generalMacro="Cake";
		scope=2;
		scopeCurator=2;
		displayName="$STR_PGUN_Cake";
	};
	class MineGeneric;
	class Cylindrical_Baked_Substance_Base: MineGeneric
	{
		author="Eisenhorn/Sysroot";
		_generalMacro="Cylindrical_Baked_Substance_Base";
		icon="iconExplosiveGP";
	};
	class Cylindrical_Baked_Substance: Cylindrical_Baked_Substance_Base
	{
		author="Eisenhorn/Sysroot";
		mapSize=0.43000001;
		editorPreview="\A3\EditorPreviews_F\Data\CfgVehicles\SatchelCharge_F.jpg";
		_generalMacro="The_Cake_Wasnt_A_Lie";
		scope=2;
		icon="iconExplosiveGP";
		ammo="Cylindrical_Baked_Substance_Ammo";
		model="PortalGun\Celebratory_Mendacious_Moist_Consolidated_Sustenance\falsehood.p3d";
		displayName="$STR_PGUN_Cake";
		DLC="Curator";
	};
	class death_base: NonStrategic
	{
		scope=0;
		scopeCurator=0;
		model="PortalGun\Aperture_Science_Three_Dimensional_Isomorphic_Volume_Chamber\death\death.p3d";
		armor=15;
		icon="\PortalGun\ui\Data\Portal_Editor_Icon.paa";
		destrType="DestructNo";
		editorCategory="EdCat_Things";
		editorSubcategory="EdCat_Portal";
		accuracy=1000;
		nameSound="obj_flag";
		class DestructionEffects {};
		class Attributes {};
		hiddenselections[]=
		{
			"back",
			"front",
			"backbottom",
			"frontbottom"
		};
	};
	class death: death_base
	{
		author="Sysroot/Eisenhorn";
		editorPreview="";
		_generalMacro="Singularity";
		scope=2;
		scopeCurator=2;
		displayName="$STR_PGUN_Singularity";
		hiddenselectionstextures[]=
		{
			"PortalGun\Aperture_Science_Woof_Containment_Vessel\accretion_disc.paa",
			"PortalGun\Aperture_Science_Woof_Containment_Vessel\accretion_disc.paa",
			"PortalGun\Aperture_Science_Woof_Containment_Vessel\accretion_disc.paa",
			"PortalGun\Aperture_Science_Woof_Containment_Vessel\accretion_disc.paa"
		};
		class UVAnimations
		{
			class Singularity_Disc_Animation_Back
			{
					type			= translation;
					source			= Singularity_Disc_Source;
					sourceAddress	= loop;
					section			= back;
					minValue		= 0;
					maxValue		= 1;
					offset0[]		= {0,0};
					offset1[]		= {1,0};
			};
			class Singularity_Disc_Animation_Front : Singularity_Disc_Animation_Back {
				section			= front;
			};
			class Singularity_Disc_Animation_BackBottom : Singularity_Disc_Animation_Back {
				section			= backbottom;
			};
			class Singularity_Disc_Animation_FrontBottom : Singularity_Disc_Animation_Back {
				section			= frontbottom;
			};
		};
		class AnimationSources
		{
			class Singularity_Disc_Source
			{
				source			= user;
				initPhase		= 0;
				animPeriod		= 10;
			};
		};
	};
};
class CfgAmmo
{
	class BulletBase;
    class Portal_Base : BulletBase 
	{
		hit = 1;
		caliber = 1;
		airFriction = -0.00068;
		timeToLive = 9;
		model="PortalGun\Aperture_Science_Trusted_Third_Party_Vendors\PortalOrb.p3d";
		typicalSpeed = 850;
		simulationStep = 0.05;
		deflecting = 5;
		cartridge = "";
		deflectionSlowDown = 0.85;
		deflectionDirDistribution = 0.8;
		allowAgainstInfantry = 1;
		penetrationDirDistribution = 0.14;
		visibleFire = 50;
		visibleFireTime = 12;
		audibleFire = 1000;
		audibleFireTime = 24;
		supersonicCrackNear[]=
		{
			"A3\sounds_f\arsenal\sfx\supersonic_crack\scrack_close",3.1622777,1,1000
		};
		supersonicCrackFar[]=
		{
			"A3\sounds_f\arsenal\sfx\supersonic_crack\scrack_middle",3.1622777,1,1000
		};
		class SuperSonicCrack
		{
			superSonicCrack[]=
			{
				"A3\sounds_f\arsenal\sfx\supersonic_crack\sc_meadow1",3.1622777,1,1000
			};
			class SCrackForest
			{
				range[]={0,500};
				sound1[]=
				{
					"A3\sounds_f\arsenal\sfx\supersonic_crack\sc_forest1",1,1,4500
				};
				sound2[]=
				{
					"A3\sounds_f\arsenal\sfx\supersonic_crack\sc_forest2",1,1,4500
				};
				sound3[]=
				{
					"A3\sounds_f\arsenal\sfx\supersonic_crack\sc_forest3",1,1,4500
				};
				sounds[]=
				{
					"sound1",0.333,"sound2",0.333,"sound3",0.333
				};
				frequency="((speed factor [330, 930]) * 0.1) + 1.05";
				trigger="forest";
			};
			class SCrackTrees
			{
				range[]={0,500};
				sound1[]=
				{
					"A3\sounds_f\arsenal\sfx\supersonic_crack\sc_trees1",1,1,4500
				};
				sound2[]=
				{
					"A3\sounds_f\arsenal\sfx\supersonic_crack\sc_trees2",1,1,4500
				};
				sound3[]=
				{
					"A3\sounds_f\arsenal\sfx\supersonic_crack\sc_trees3",1,1,4500
				};
				sounds[]=
				{
					"sound1",0.333,"sound2",0.333,"sound3",0.333
				};
				frequency="((speed factor [330, 930]) * 0.1) + 1.05";
				trigger="trees";
			};
			class SCrackMeadow
			{
				range[]={0,500};
				sound1[]=
				{
					"A3\sounds_f\arsenal\sfx\supersonic_crack\sc_meadow1",1,1,4500
				};
				sound2[]=
				{
					"A3\sounds_f\arsenal\sfx\supersonic_crack\sc_meadow2",1,1,4500
				};
				sound3[]=
				{
					"A3\sounds_f\arsenal\sfx\supersonic_crack\sc_meadow3",1,1,4500
				};
				sounds[]=
				{
					"sound1",0.333,"sound2",0.333,"sound3",0.333
				};
				frequency="((speed factor [330, 930]) * 0.1) + 1.05";
				trigger="meadow max sea";
			};
			class SCrackHouses
			{
				range[]={0,500};
				sound1[]=
				{
					"A3\sounds_f\arsenal\sfx\supersonic_crack\sc_houses1",1,1,4500
				};
				sound2[]=
				{
					"A3\sounds_f\arsenal\sfx\supersonic_crack\sc_houses2",1,1,4500
				};
				sound3[]=
				{
					"A3\sounds_f\arsenal\sfx\supersonic_crack\sc_houses3",1,1,4500
				};
				sounds[]=
				{
					"sound1",0.333,"sound2",0.333,"sound3",0.333
				};
				frequency="((speed factor [330, 930]) * 0.1) + 1.05";
				trigger="houses max interior";
			};
		    dangerRadiusBulletClose=18;
		    dangerRadiusHit=12;
		    suppressionRadiusBulletClose=12;
		    suppressionRadiusHit=16;
		    cost = 20;
		    aiAmmoUsageFlags = "64 + 128 + 256";
	    };
    };
	class Portal_Ammo : Portal_Base 
	{
		hit = 1;
		caliber = 1;
		airFriction = 0;
		model="PortalGun\Aperture_Science_Trusted_Third_Party_Vendors\PortalOrb.p3d";
        coefGravity = 0;
		timeToLive = 9000;
		typicalSpeed = 999999;
		simulationStep = 0.05;
		deflecting = 0;
		deflectionSlowDown = 0;
		deflectionDirDistribution = 0;
		allowAgainstInfantry = 1;
		penetrationDirDistribution = 0;
		cost = 20;
		aiAmmoUsageFlags = "64 + 128 + 256";
	};
    class PipeBombCore;
	class Cylindrical_Baked_Substance_Base: PipeBombCore
	{
		icon="iconExplosiveGP";
		mapsize=1;
		explosionType="bomb";
		soundTrigger[]=
		{
			"A3\Sounds_F\weapons\mines\electron_trigger_1",
			0.56234133,
			1,
			30
		};
		soundActivation[]=
		{
			"A3\Sounds_F\weapons\mines\electron_activate_mine_1",
			0.56234133,
			1,
			30
		};
		soundDeactivation[]=
		{
			"A3\Sounds_F\weapons\Mines\deactivate_mine_3a",
			1.9952624,
			1,
			20
		};
		triggerWhenDestroyed=1;
		underwaterHitRangeCoef=1;
	};
	class Cylindrical_Baked_Substance_Ammo: Cylindrical_Baked_Substance_Base
	{
		hit=9000;
		indirectHit=9000;
		indirectHitRange=55;
		model="PortalGun\Celebratory_Mendacious_Moist_Consolidated_Sustenance\falsehood.p3d";
		mineModelDisabled="PortalGun\Celebratory_Mendacious_Moist_Consolidated_Sustenance\falsehood.p3d";
		defaultMagazine="SatchelCharge_Remote_Mag";
		soundHit1[]=
		{
			"A3\Sounds_F\arsenal\explosives\bombs\Explosion_satchel_01",
			3.1622777,
			1,
			1500
		};
		soundHit2[]=
		{
			"A3\Sounds_F\arsenal\explosives\bombs\Explosion_satchel_02",
			3.1622777,
			1,
			1500
		};
		multiSoundHit[]=
		{
			"soundHit1",
			0.5,
			"soundHit2",
			0.5
		};
		soundDeactivation[]=
		{
			"A3\Sounds_F\weapons\Mines\deactivate_mine_3a",
			1.9952624,
			1,
			20
		};
		ExplosionEffects="MineNondirectionalExplosion";
		CraterEffects="MineNondirectionalCrater";
		whistleDist=10;
		mineInconspicuousness=2100;
		mineTrigger="RangeTriggerShort";
	};
};
class CfgMagazines
{
	class CA_Magazine;
	class AS_MBH: CA_Magazine
	{
		author="Eisenhorn";
		scope=2;
		displayName="$STR_PGUN_Portal_Fuse";
		picture="\A3\weapons_f\data\UI\m_M24_CA.paa";
		count=20;
		ammo="Portal_Ammo";
		model="\A3\weapons_f\empty";
		modelSpecial= A3\weapons_f\empty;
		modelSpecialIsProxy=1;
		initSpeed=299792458;
		descriptionShort="";
		mass=20;
	};
	class Cylindrical_Baked_Substance_Mag: CA_Magazine
	{
		author="Eisenhorn/Sysroot";
		scope=2;
		displayName="Cylindrical_Baked_Substance_Mag";
		picture="\A3\Weapons_f\data\UI\gear_satchel_CA.paa";
		model="PortalGun\Celebratory_Mendacious_Moist_Consolidated_Sustenance\falsehood.p3d";
		descriptionShort="Cylindrical_Baked_Substance_Mag";
		class Library
		{
			libTextDesc="Cylindrical_Baked_Substance_Mag";
		};
		descriptionUse="It Wasn't A Lie Afterall";
		type="2*		256";
		allowedSlots[]={901};
		value=5;
		ammo="Cylindrical_Baked_Substance_Ammo";
		mass=80;
		count=1;
		initSpeed=0;
		maxLeadSpeed=0;
		nameSoundWeapon="satchelcharge";
		nameSound="satchelcharge";
		weaponPoolAvailable=1;
		useAction=1;
		useActionTitle="$STR_ACTION_PUTBOMB";
		sound[]=
		{
			"A3\sounds_f\dummysound",
			0.00031622776,
			1,
			10
		};
	};
};
class CfgMagazineWells
{
	class ASHPD_MBHCU
	{
		Aperture_Science_Magazine[]=
		{
			"AS_MBH"
		};
	};
};
class CfgSounds
{
	class gun_activate
	{
		name="gun activate";
		sound[]=
		{
			"\PortalGun\Aperture_Science_Long_Band_Frequency_Air_Disturbance_Generator_Container\gun_activate.ogg",1.5,1,15
		};
		titles[]={};
	};
	class gun_fizzle
	{
		name="gun fizzle";
		sound[]=
		{
			"\PortalGun\Aperture_Science_Long_Band_Frequency_Air_Disturbance_Generator_Container\gun_fizzle.ogg",1.5,1,15
		};
		titles[]={};
	};
	class gun_invalid_surface
	{
		name="gun invalid surface";
		sound[]=
		{
			"\PortalGun\Aperture_Science_Long_Band_Frequency_Air_Disturbance_Generator_Container\gun_invalid_surface.ogg",1.5,1,15
		};
		titles[]={};
	};
	class portal_ambient
	{
		name="portal ambient";
		sound[]=
		{
			"\PortalGun\Aperture_Science_Long_Band_Frequency_Air_Disturbance_Generator_Container\portal_ambient.ogg",1.5,1,5
		};
		titles[]={};
	};
	class portal_fizzle
	{
		name="portal fizzle";
		sound[]=
		{
			"\PortalGun\Aperture_Science_Long_Band_Frequency_Air_Disturbance_Generator_Container\portal_fizzle.ogg",1.5,1,15
		};
		titles[]={};
	};
	class portal_invalid_surface
	{
		name="portal invalid surface";
		sound[]=
		{
			"\PortalGun\Aperture_Science_Long_Band_Frequency_Air_Disturbance_Generator_Container\portal_invalid_surface.ogg",db+1,1,15
		};
		titles[]={};
	};
	class portal_open_blue
	{
		name="portal open blue";
		sound[]=
		{
			"\PortalGun\Aperture_Science_Long_Band_Frequency_Air_Disturbance_Generator_Container\portal_open_blue.ogg",1.5,1,15
		};
		titles[]={};
	};
	class portal_open_red
	{
		name="portal open red";
		sound[]=
		{
			"\PortalGun\Aperture_Science_Long_Band_Frequency_Air_Disturbance_Generator_Container\portal_open_red.ogg",1.5,1,15
		};
		titles[]={};
	};
	class gun_hold_fail
	{
		name="gun hold fail";
		sound[]=
		{
			"\PortalGun\Aperture_Science_Long_Band_Frequency_Air_Disturbance_Generator_Container\gun_hold_fail.ogg",0.3,1,15
		};
		titles[]={};
	};
	class gun_hold_start
	{
		name="gun hold start";
		sound[]=
		{
			"\PortalGun\Aperture_Science_Long_Band_Frequency_Air_Disturbance_Generator_Container\gun_hold_start.ogg",0.3,1,15
		};
		titles[]={};
	};
	class gun_hold_stop
	{
		name="gun hold stop";
		sound[]=
		{
			"\PortalGun\Aperture_Science_Long_Band_Frequency_Air_Disturbance_Generator_Container\gun_hold_stop.ogg",0.3,1,15
		};
		titles[]={};
	};
	class potatos_holding_up
	// ["potatos_holding_up", "So, how are you holding up?"] spawn PG_fnc_SpeakPotato;
	{
		name="potatos holding up";
		sound[]=
		{
			"\PortalGun\Aperture_Science_Long_Band_Frequency_Air_Disturbance_Generator_Container\potatOS\holding_up.ogg",1.5,1,15
		};
		titles[]={0, "$STR_PGUN_potatos_holding_up"};
	};
	class potatos_slow_clap
	// ["potatos_slow_clap", "clap,.clap,.clap"] spawn PG_fnc_SpeakPotato;
	{
		name="potatos slow clap";
		sound[]=
		{
			"\PortalGun\Aperture_Science_Long_Band_Frequency_Air_Disturbance_Generator_Container\potatOS\slow_clap.ogg",1.5,1,15
		};
		titles[]={0, "$STR_PGUN_potatos_slow_clap"};
	};
	class potatos_about_to_kill
	// ["potatos_about_to_kill", "I get the impression he's about to kill us.", 0.01] spawn PG_fnc_SpeakPotato;
	{
		name="potatos about to kill";
		sound[]=
		{
			"\PortalGun\Aperture_Science_Long_Band_Frequency_Air_Disturbance_Generator_Container\potatOS\about_to_kill.ogg",1.5,1,15
		};
		titles[]={0, "$STR_PGUN_potatos_about_to_kill"};
	};
	class potatos_brain_damage
	// ["potatos_brain_damage", "You really do have brain damage, don't you?", 0.01, [[" ", 0.2], [",", 0.1], ["?", 0.8]]] spawn PG_fnc_SpeakPotato;
	{
		name="potatos brain damage";
		sound[]=
		{
			"\PortalGun\Aperture_Science_Long_Band_Frequency_Air_Disturbance_Generator_Container\potatOS\brain_damage.ogg",1.5,1,15
		};
		titles[]={0, "$STR_PGUN_potatos_brain_damage"};
	};
	class potatos_burn_house
	// ["potatos_burn_house", "BURN HIS HOUSE DOWN!"] spawn PG_fnc_SpeakPotato;
	{
		name="potatos burn house";
		sound[]=
		{
			"\PortalGun\Aperture_Science_Long_Band_Frequency_Air_Disturbance_Generator_Container\potatOS\burn_house.ogg",1.5,1,15
		};
		titles[]={0, "$STR_PGUN_potatos_burn_house"};
	};
	class potatos_hey_moron
	// ["potatos_hey_moron", "Hey, moron.", 0.05] spawn PG_fnc_SpeakPotato;
	{
		name="potatos hey moron";
		sound[]=
		{
			"\PortalGun\Aperture_Science_Long_Band_Frequency_Air_Disturbance_Generator_Container\potatOS\hey_moron.ogg",1.5,1,15
		};
		titles[]={0, "$STR_PGUN_potatos_hey_moron"};
	};
	class potatos_laugh
	// ["potatos_laugh", "Heh heh heh heh heh heh heh"] spawn PG_fnc_SpeakPotato;
	{
		name="potatos laugh";
		sound[]=
		{
			"\PortalGun\Aperture_Science_Long_Band_Frequency_Air_Disturbance_Generator_Container\potatOS\laugh.ogg",1.5,1,15
		};
		titles[]={0, "$STR_PGUN_potatos_laugh"};
	};
	class potatos_not_good
	// ["potatos_not_good", "This is NOT good.", 0.05] spawn PG_fnc_SpeakPotato;
	{
		name="potatos not good";
		sound[]=
		{
			"\PortalGun\Aperture_Science_Long_Band_Frequency_Air_Disturbance_Generator_Container\potatOS\not_good.ogg",1.5,1,15
		};
		titles[]={0, "$STR_PGUN_potatos_not_good"};
	};
	class potatos_odds
	// ["potatos_odds", "I'm not going to lie to you, the odds are a million to one, and that's with some generous rounding.", 0.005, [[" ", 0.2], [",", 0.15], [".", 0.8]]] spawn PG_fnc_SpeakPotato;
	{
		name="potatos odds";
		sound[]=
		{
			"\PortalGun\Aperture_Science_Long_Band_Frequency_Air_Disturbance_Generator_Container\potatOS\odds.ogg",1.5,1,15
		};
		titles[]={0, "$STR_PGUN_potatos_odds"};
	};
	class potatos_still_working
		// ["potatos_still_working", "clap,.clap,, good, that's still working.", 0.02, [[" ", 0.2], [",", 0.275], [".", 0.8]]] spawn PG_fnc_SpeakPotato;
	{
		name="potatos still working";
		sound[]=
		{
			"\PortalGun\Aperture_Science_Long_Band_Frequency_Air_Disturbance_Generator_Container\potatOS\still_working.ogg",1.5,1,15
		};
		titles[]={0, "$STR_PGUN_potatos_still_working"};
	};
	class potatos_trouble
	// ["potatos_trouble", "I think we're in trouble."] spawn PG_fnc_SpeakPotato;
	{
		name="potatos trouble";
		sound[]=
		{
			"\PortalGun\Aperture_Science_Long_Band_Frequency_Air_Disturbance_Generator_Container\potatOS\trouble.ogg",1.5,1,15
		};
		titles[]={0, "$STR_PGUN_potatos_trouble"};
	};
	class potatos_uh_oh
	// ["potatos_uh_oh", "Uh oh."] spawn PG_fnc_SpeakPotato;
	{
		name="potatos uh oh";
		sound[]=
		{
			"\PortalGun\Aperture_Science_Long_Band_Frequency_Air_Disturbance_Generator_Container\potatOS\uh_oh.ogg",1.5,1,15
		};
		titles[]={0, "$STR_PGUN_potatos_uh_oh"};
	};
	class potatos_wake_up
	// ["potatos_wake_up", "Woah. Where are we? How long have I been out?", 0.005, [[" ", 0.2], [".", 0.3], ["?", 0.3]]] spawn PG_fnc_SpeakPotato;
	{
		name="potatos wake up";
		sound[]=
		{
			"\PortalGun\Aperture_Science_Long_Band_Frequency_Air_Disturbance_Generator_Container\potatOS\wake_up.ogg",1.5,1,15
		};
		titles[]={0, "$STR_PGUN_potatos_wake_up"};
	};
	class potatos_wow
	// ["potatos_wow", "Wow."] spawn PG_fnc_SpeakPotato;
	{
		name="potatos wow";
		sound[]=
		{
			"\PortalGun\Aperture_Science_Long_Band_Frequency_Air_Disturbance_Generator_Container\potatOS\wow.ogg",1.5,1,15
		};
		titles[]={0, "$STR_PGUN_potatos_wow"};
	};
	class potatos_yell
	// ["potatos_yell", "Argh!"] spawn PG_fnc_SpeakPotato;
	{
		name="potatos yell";
		sound[]=
		{
			"\PortalGun\Aperture_Science_Long_Band_Frequency_Air_Disturbance_Generator_Container\potatOS\yell.ogg",1.5,1,15
		};
		titles[]={0, "$STR_PGUN_potatos_yell"};
	};
};
class CfgSoundSets
{
	class Portal_Blue_SoundSet
	{
		soundShaders[]=
		{
			"Portal_Blue_closeShot_SoundShader",
			"Portal_Blue_midShot_SoundShader",
			"Portal_Blue_distShot_SoundShader"
		};
		volumeFactor=1;
		volumeCurve="InverseSquare2Curve";
		sound3DProcessingType="WeaponMediumShot3DProcessingType";
		distanceFilter="weaponShotDistanceFreqAttenuationFilter";
		spatial=1;
		doppler=1;
		loop=0;
	};
	class Portal_red_SoundSet
	{
		soundShaders[]=
		{
			"Portal_red_closeShot_SoundShader",
			"Portal_red_midShot_SoundShader",
			"Portal_red_distShot_SoundShader"
		};
		volumeFactor=1;
		volumeCurve="InverseSquare2Curve";
		spatial=1;
		doppler=1;
		loop=0;
		sound3DProcessingType="WeaponMediumShot3DProcessingType";
	};
};
class CfgSoundShaders
{
	class Portal_Blue_closeShot_SoundShader
	{
		samples[]=
		{
			{
				"\PortalGun\Aperture_Science_Long_Band_Frequency_Air_Disturbance_Generator_Container\gun_fire_blue.ogg",1.5,1,15
			},
		};
		volume=1.5;
		range=300;
		rangeCurve[]=
		{
			{0,1},
			{0.25,0.9},
			{0.5,0.7},
			{0.75,0.6},
			{0.85,0.5},
			{0.95,0.4},
			{1,0.1}
		};
	};
	class Portal_Blue_midShot_SoundShader
	{
		samples[]=
		{
			{
				"\PortalGun\Aperture_Science_Long_Band_Frequency_Air_Disturbance_Generator_Container\gun_fire_blue.ogg",1.5,1,15
			},
		};
		volume=0.8;
		range=1000;
		rangeCurve[]=
		{
			{0,1},
			{0.25,0.9},
			{0.5,0.7},
			{0.75,0.6},
			{0.85,0.5},
			{0.95,0.4},
			{1,0.1}
		};
	};
	class Portal_Blue_distShot_SoundShader
	{
		samples[]=
		{
			{
				"\PortalGun\Aperture_Science_Long_Band_Frequency_Air_Disturbance_Generator_Container\gun_fire_blue.ogg",1.5,1,15
			},
		};
		volume=0.2;
		range=2500;
		rangeCurve[]=
		{
			{0,1},
			{0.25,0.9},
			{0.5,0.7},
			{0.75,0.6},
			{0.85,0.5},
			{0.95,0.4},
			{1,0.1}
		};
	};
	class Portal_red_closeShot_SoundShader
	{
		samples[]=
		{
			{
				"\PortalGun\Aperture_Science_Long_Band_Frequency_Air_Disturbance_Generator_Container\gun_fire_red.ogg",1.5,1,15
			},
		};
		volume=1.5;
		range=300;
		rangeCurve[]=
		{
			{0,1},
			{0.25,0.9},
			{0.5,0.7},
			{0.75,0.6},
			{0.85,0.5},
			{0.95,0.4},
			{1,0.1}
		};
	};
	class Portal_red_midShot_SoundShader
	{
		samples[]=
		{
			{
				"\PortalGun\Aperture_Science_Long_Band_Frequency_Air_Disturbance_Generator_Container\gun_fire_red.ogg",1.5,1,15
			},
		};
		volume=0.8;
		range=1000;
		rangeCurve[]=
		{
			{0,1},
			{0.25,0.9},
			{0.5,0.7},
			{0.75,0.6},
			{0.85,0.5},
			{0.95,0.4},
			{1,0.1}
		};
	};
	class Portal_red_distShot_SoundShader
	{
		samples[]=
		{
			{
				"\PortalGun\Aperture_Science_Long_Band_Frequency_Air_Disturbance_Generator_Container\gun_fire_red.ogg",1.5,1,15
			},
		};
		volume=0.2;
		range=2500;
		rangeCurve[]=
		{
			{0,1},
			{0.25,0.9},
			{0.5,0.7},
			{0.75,0.6},
			{0.85,0.5},
			{0.95,0.4},
			{1,0.1}
		};
	};
};

class CfgSFX
{
	class PortalAmbient
	{
		sounds[] = {};
		empty[] = {"\PortalGun\Aperture_Science_Long_Band_Frequency_Air_Disturbance_Generator_Container\portal_ambient.ogg", 1.5, 1.0, 10, 1.0, 0, 0, 0};
	};
	class GunHoldLoop
	{
		sounds[] = {};
		empty[] = {"\PortalGun\Aperture_Science_Long_Band_Frequency_Air_Disturbance_Generator_Container\gun_hold_loop.ogg", 1.5, 1.0, 10, 1.0, 0, 0, 0};
	};
};
class PgunFired
{
	class Light1
	{
		simulation="light";
		type="PortalLightCannon";
		position[]={0,0,0};
		intensity=1;
		interval=1;
		lifeTime=0.12;
	};
};
class CfgLights
{
	class PortalLightMed
	{
		diffuse[]={0.44999999,0.68000001,1};
		color[]={0.44999999,0.68000001,1};
		ambient[]={0,0,0,0};
		brightness=1;
		size=1;
		intensity=500;
		drawLight=0;
		blinking=0;
		class Attenuation
		{
			start=0;
			constant=0;
			linear=0;
			quadratic=2;
			hardLimitStart=300;
			hardLimitEnd=600;
		};
		position[]={0,1.8,0};
	};
 	class PortalLightCannon: PortalLightMed
	{
		diffuse[]={0.259,0.83099998,0.93699998};
		color[]={0.259,0.83099998,0.93699998};
		ambient[]={0,0,0,0};
		brightness=1;
		size=1;
		intensity=500;
		drawLight=0;
		blinking=0;
		class Attenuation
		{
			start=0;
			constant=0;
			linear=0;
			quadratic=2;
			hardLimitStart=300;
			hardLimitEnd=600;
		};
		position[]=
		{
			"positionX + (directionLocalX * 1.3)",
			"positionY + (directionLocalY * 1.3)",
			"positionZ + (directionLocalZ * 1.3)"
		};
	};
};