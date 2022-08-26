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
		scope = 1;
		displayName = "PotatOS";
		model = "";
		author = "";
		picture = "";
		UiPicture = "";
		class ItemInfo: InventoryFlashLightItem_Base_F
		{
			mass = 0.002;
			class Pointer {};
		};
	};
	class GrenadeLauncher;
	class Rifle;
	class Portal_Base_F: Rifle
	{
		scope = 0;
		discreteDistance[] = { 0,
			1,
			2,
			3
		};
		discreteDistanceInitIndex = 0;
		weaponInfoType = "RscWeaponZeroing";
		recoil = "recoil_default";
		deployedPivot = "bipod";
		class GunParticles
		{
			class FirstEffect
			{
				effectName = "PgunFired";
				positionName = "Usti hlavne";
				directionName = "Konec hlavne";
			};
		};
	};
	class ASHPD_MK_SUS_Base_F: Portal_Base_F
	{
		author = "Sysroot & Eisenhorn";
		_generalMacro = "ASHPD_MK_SUS_Base_F";
		visibleFire = 50;
		visibleFireTime = 12;
		audibleFire = 1000;
		audibleFireTime = 24;
		scope = 0;
		magazines[] = { "AS_MBH" };
		magazineWell[] = { "ASHPD_MBHCU" };
		displayName = "$STR_PGUN_Name_Long";
		model = "PortalGun\Aperture_Science_Three_Dimensional_Isomorphic_Volume_Chamber\ApertureScienceHandheldPortalDevice.p3d";
		picture = "\A3\weapons_F\Rifles\MX\data\UI\gear_mx_cqc_X_CA.paa";
		UiPicture = "\A3\weapons_f\data\UI\icon_regular_CA.paa";
		muzzles[] = { "this" };
		handAnim[] = { "OFP2_ManSkeleton",
			"PortalGun\Aperture_Science_Eccentric_Contraction_Coordinates\ASHPD.rtm" };
		reloadAction = "Disable_Gesture";
		recoil = "recoil_gm6";
		weaponInfoType = "RscWeaponEmpty";
		cursor = "EmptyCursor";
		initSpeed = 299792458;
		caseless[] = { "",
			1,
			1,
			1
		};
		soundBullet[] = { "caseless",
			1
		};
		class WeaponSlotsInfo
		{
			mass = 100;
		};
		maxRecoilSway = 0.0125;
		swayDecaySpeed = 1.25;
		inertia = 0.4;
		aimTransitionSpeed = 1.2;
		dexterity = 1.6;
		maxZeroing = 800;
		class ItemInfo
		{
			priority = 1;
		};
		modes[] = { "Blue",
			"Orange" };
		descriptionShort = "Portal_Device";
		class Blue: Mode_SemiAuto
		{
			reloadTime = 0.25;
			dispersion = 0;
			minRange = 2;
			minRangeProbab = 0.3;
			midRange = 150;
			midRangeProbab = 0.7;
			maxRange = 350;
			maxRangeProbab = 0.1;
			displayname = "$STR_PGUN_Primary_Portal";
			sounds[] = { "StandardSound" };
			class BaseSoundModeType
			{
				closure1[] = { "A3\Sounds_F\arsenal\weapons\UGL\Closure_UGL",
					1,
					1,
					10
				};
				soundClosure[] = { "closure1",
					1
				};
			};
			class StandardSound: BaseSoundModeType
			{
				begin1[] = { "\PortalGun\Aperture_Science_Long_Band_Frequency_Air_Disturbance_Generator_Container\gun_fire_Blue.ogg",
					0.70794576,
					1,
					200
				};
				begin2[] = { "\PortalGun\Aperture_Science_Long_Band_Frequency_Air_Disturbance_Generator_Container\gun_fire_Blue.ogg",
					0.70794576,
					1,
					200
				};
				soundBegin[] = { "begin1",
					0.5,
					"begin2",
					0.5
				};
			};
		};
		class Orange: Mode_SemiAuto
		{
			reloadTime = 0.25;
			dispersion = 0;
			minRange = 2;
			minRangeProbab = 0.3;
			midRange = 150;
			midRangeProbab = 0.7;
			maxRange = 350;
			maxRangeProbab = 0.1;
			displayname = "$STR_PGUN_Secondary_Portal";
			sounds[] = { "StandardSound" };
			class BaseSoundModeType
			{
				closure1[] = { "A3\Sounds_F\arsenal\weapons\UGL\Closure_UGL",
					1,
					1,
					10
				};
				soundClosure[] = { "closure1",
					1
				};
			};
			class StandardSound: BaseSoundModeType
			{
				begin1[] = { "\PortalGun\Aperture_Science_Long_Band_Frequency_Air_Disturbance_Generator_Container\gun_fire_red.ogg",
					0.70794576,
					1,
					200
				};
				begin2[] = { "\PortalGun\Aperture_Science_Long_Band_Frequency_Air_Disturbance_Generator_Container\gun_fire_red.ogg",
					0.70794576,
					1,
					200
				};
				soundBegin[] = { "begin1",
					0.5,
					"begin2",
					0.5
				};
			};
		};
		class single_medium_optics1: Blue
		{
			showToPlayer = 0;
			reloadTime = 0.25;
			dispersion = 0;
			minRange = 2;
			minRangeProbab = 0.2;
			midRange = 350;
			midRangeProbab = 0.7;
			maxRange = 500;
			maxRangeProbab = 0.3;
			aiRateOfFire = 5;
			aiRateOfFireDistance = 500;
		};
		class single_medium_optics2: single_medium_optics1
		{
			showToPlayer = 0;
			reloadTime = 0.25;
			dispersion = 0;
			requiredOpticType = 2;
			minRange = 100;
			minRangeProbab = 0.1;
			midRange = 400;
			midRangeProbab = 0.6;
			maxRange = 700;
			maxRangeProbab = 0.05;
			aiRateOfFire = 7;
			aiRateOfFireDistance = 700;
		};
		aiDispersionCoefY = 6;
		aiDispersionCoefX = 4;
	};
	class ASHPD_MK_SUS: ASHPD_MK_SUS_Base_F
	{
		author = "Sysroot & Eisenhorn";
		baseWeapon = "ASHPD_MK_SUS";
		_generalMacro = "ASHPD_MK_SUS";
		scope = 2;
		scopeCurator = 2;
		scopeArsenal = 2;
		model = "PortalGun\Aperture_Science_Three_Dimensional_Isomorphic_Volume_Chamber\ApertureScienceHandheldPortalDevice.p3d";
		displayName = "$STR_PGUN_Name_Long";
		changeFiremodeSound[] = { "A3\sounds_f\weapons\closure\firemode_changer_2",
			0.551189,
			1,
			5
		};
		picture = "\PortalGun\ui\Data\Weapon_Icon.paa";
		descriptionShort = "$STR_PGUN_Description";
		class WeaponSlotsInfo: WeaponSlotsInfo
		{
			mass = 100;
		};
		class ItemInfo
		{
			priority = 1;
		};
	};
	class ASHPD_MK_SUS_P: ASHPD_MK_SUS_Base_F
	{
		author = "Sysroot & Eisenhorn";
		baseWeapon = "ASHPD_MK_SUS_P";
		_generalMacro = "ASHPD_MK_SUS_P";
		scope = 2;
		scopeCurator = 2;
		scopeArsenal = 2;
		model = "PortalGun\Aperture_Science_Three_Dimensional_Isomorphic_Volume_Chamber\ApertureScienceHandheldPortalDevicePotato.p3d";
		displayName = "$STR_PGUN_Name_P_Long";
		changeFiremodeSound[] = { "A3\sounds_f\weapons\closure\firemode_changer_2",
			0.551189,
			1,
			5
		};
		picture = "\PortalGun\ui\Data\Weapon_Icon_Potato.paa";
		descriptionShort = "$STR_PGUN_P_Description";
		class WeaponSlotsInfo: WeaponSlotsInfo
		{
			mass = 100;
			class PointerSlot
			{
				compatibleItems[] = { "GeneticLifeFormandDiskOperatingSystem" };
			};
		};
		class ItemInfo
		{
			priority = 1;
		};
	};
	class Put: Default
	{
		muzzles[] +=
		{ "Cylindrical_Baked_Substance_Muzzle" };
		displayName = "$STR_A3_CfgWeapons_Put0";
		class PutMuzzle;
		class Cylindrical_Baked_Substance_Muzzle: PutMuzzle
		{
			autoreload = 0;
			magazines[] = { "Cylindrical_Baked_Substance_Mag" };
			enableAttack = 1;
			showToPlayer = 0;
		};
	};
	class Throw: GrenadeLauncher
	{
		muzzles[] +=
		{ "Combustible_Lemon_Yeeter" };
		class ThrowMuzzle;
		class Combustible_Lemon_Yeeter: ThrowMuzzle
		{
			magazines[] = { "LemonCombustible" };
		};
	};
};