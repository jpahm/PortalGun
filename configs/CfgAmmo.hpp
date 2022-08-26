class CfgAmmo
{
	class BulletCore;
	class BulletBase2: BulletCore
	{
		visibleFire=3;
		audibleFire=40;
		visibleFireTime=2;
		dangerRadiusBulletClose=4;
		dangerRadiusHit=-1;
		suppressionRadiusBulletClose=2;
		suppressionRadiusHit=4;
		hit=8;
		indirectHit=0;
		indirectHitRange=0;
		model="\A3\Weapons_f\ammo\shell";
		caliber=1;
		cartridge="FxCartridge_556";
		cost=1;
		timeToLive=6;
		deflecting=15;
		tracerStartTime=-1;
		muzzleEffect="";
		waterEffectOffset=0.80000001;
		effectFly="AmmoClassic";
		aiAmmoUsageFlags="64 + 128 + 256";

		class HitEffects
		{
			Hit_Foliage_green="ImpactLeavesGreen";
			Hit_Foliage_Dead="ImpactLeavesDead";
			Hit_Foliage_Green_big="ImpactLeavesGreenBig";
			Hit_Foliage_Palm="ImpactLeavesPalm";
			Hit_Foliage_Pine="ImpactLeavesPine";
			hitFoliage="ImpactLeaves";
			hitGlass="ImpactGlass";
			hitGlassArmored="ImpactGlassThin";
			hitWood="ImpactWood";
			hitHay="ImpactHay";
			hitMetal="ImpactMetal";
			hitMetalPlate="ImpactMetal";
			hitBuilding="ImpactPlaster";
			hitPlastic="ImpactPlastic";
			hitRubber="ImpactRubber";
			hitTyre="ImpactTyre";
			hitConcrete="ImpactConcrete";
			hitMan="ImpactEffectsBlood";
			hitGroundSoft="ImpactEffectsSmall";
			hitGroundRed="ImpactEffectsRed";
			hitGroundHard="ImpactEffectsHardGround";
			hitWater="ImpactEffectsWater";
			hitVirtual="ImpactMetal";
		};
		class CamShakeExplode
		{
			power=1.7320499;
			duration=0.4;
			frequency=20;
			distance=5.1961498;
		};
		class CamShakeHit
		{
			power=3;
			duration=0.2;
			frequency=20;
			distance=1;
		};
		class CamShakeFire
		{
			power=0;
			duration=0;
			frequency=0;
			distance=0;
		};
		class CamShakePlayerFire
		{
			power=0;
			duration=0;
			frequency=0;
			distance=0;
		};
	};
	class Portal_Base: BulletBase2
	{
		hit = 1;
		caliber = 1;
		airFriction = -0.00068;
		timeToLive = 0.1;
		model = "";
		typicalSpeed = 0.1;
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
		supersonicCrackNear[] = { "A3\sounds_f\arsenal\sfx\supersonic_crack\scrack_close",
			3.1622777,
			1,
			1000
		};
		supersonicCrackFar[] = { "A3\sounds_f\arsenal\sfx\supersonic_crack\scrack_middle",
			3.1622777,
			1,
			1000
		};
		class SuperSonicCrack
		{
			superSonicCrack[] = { "A3\sounds_f\arsenal\sfx\supersonic_crack\sc_meadow1",
				3.1622777,
				1,
				1000
			};
			class SCrackForest
			{
				range[] = { 0,
					500
				};
				sound1[] = { "A3\sounds_f\arsenal\sfx\supersonic_crack\sc_forest1",
					1,
					1,
					4500
				};
				sound2[] = { "A3\sounds_f\arsenal\sfx\supersonic_crack\sc_forest2",
					1,
					1,
					4500
				};
				sound3[] = { "A3\sounds_f\arsenal\sfx\supersonic_crack\sc_forest3",
					1,
					1,
					4500
				};
				sounds[] = { "sound1",
					0.333,
					"sound2",
					0.333,
					"sound3",
					0.333
				};
				frequency = "((speed factor[330, 930]) *0.1) + 1.05";
				trigger = "forest";
			};
			class SCrackTrees
			{
				range[] = { 0,
					500
				};
				sound1[] = { "A3\sounds_f\arsenal\sfx\supersonic_crack\sc_trees1",
					1,
					1,
					4500
				};
				sound2[] = { "A3\sounds_f\arsenal\sfx\supersonic_crack\sc_trees2",
					1,
					1,
					4500
				};
				sound3[] = { "A3\sounds_f\arsenal\sfx\supersonic_crack\sc_trees3",
					1,
					1,
					4500
				};
				sounds[] = { "sound1",
					0.333,
					"sound2",
					0.333,
					"sound3",
					0.333
				};
				frequency = "((speed factor[330, 930]) *0.1) + 1.05";
				trigger = "trees";
			};
			class SCrackMeadow
			{
				range[] = { 0,
					500
				};
				sound1[] = { "A3\sounds_f\arsenal\sfx\supersonic_crack\sc_meadow1",
					1,
					1,
					4500
				};
				sound2[] = { "A3\sounds_f\arsenal\sfx\supersonic_crack\sc_meadow2",
					1,
					1,
					4500
				};
				sound3[] = { "A3\sounds_f\arsenal\sfx\supersonic_crack\sc_meadow3",
					1,
					1,
					4500
				};
				sounds[] = { "sound1",
					0.333,
					"sound2",
					0.333,
					"sound3",
					0.333
				};
				frequency = "((speed factor[330, 930]) *0.1) + 1.05";
				trigger = "meadow max sea";
			};
			class SCrackHouses
			{
				range[] = { 0,
					500
				};
				sound1[] = { "A3\sounds_f\arsenal\sfx\supersonic_crack\sc_houses1",
					1,
					1,
					4500
				};
				sound2[] = { "A3\sounds_f\arsenal\sfx\supersonic_crack\sc_houses2",
					1,
					1,
					4500
				};
				sound3[] = { "A3\sounds_f\arsenal\sfx\supersonic_crack\sc_houses3",
					1,
					1,
					4500
				};
				sounds[] = { "sound1",
					0.333,
					"sound2",
					0.333,
					"sound3",
					0.333
				};
				frequency = "((speed factor[330, 930]) *0.1) + 1.05";
				trigger = "houses max interior";
			};
			dangerRadiusBulletClose = 18;
			dangerRadiusHit = 12;
			suppressionRadiusBulletClose = 12;
			suppressionRadiusHit = 16;
			cost = 20;
			aiAmmoUsageFlags = "64 + 128 + 256";
		};
	};
	class Portal_Ammo: Portal_Base
	{
		hit = 1;
		caliber = 1;
		airFriction = 0;
		model = "PortalGun\Aperture_Science_Trusted_Third_Party_Vendors\PortalOrb.p3d";
		coefGravity = 0;
		timeToLive = 0.1;
		typicalSpeed = 0.1;
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
	class MineBase;
	class Cylindrical_Baked_Substance_Ammo: MineBase
	{
		hit = 19000;
		indirectHit = 19000;
		indirectHitRange = 55;
		model = "PortalGun\Celebratory_Mendacious_Moist_Consolidated_Sustenance\falsehood.p3d";
		mineModelDisabled = "PortalGun\Celebratory_Mendacious_Moist_Consolidated_Sustenance\falsehood.p3d";
		defaultMagazine = "";
		soundHit[] = {"A3\Sounds_F\weapons\mines\underwater_mine_1",20.0,1,2000};
		soundDeactivation[] = {"A3\Sounds_F\weapons\mines\deactivate_UWmine_2",1.9952624,1,20};
		ExplosionEffects = "MineUnderwaterPDMExplosion";
		CraterEffects = "MineNondirectionalCrater";
		whistleDist = 10;
		mineInconspicuousness = 2100;
		mineTrigger = "RangeTriggerShort";
	};
	class Grenade;
	class Combustible_Lemon: Grenade
	{
		scope = 2;
		scopeArsenal = 2;
		scopeCurator = 2;
		author = "Sysroot & Eisenhorn";
		hit = 15;
		indirectHit = 20;
		indirectHitRange = 6;
		deflecting = 5;
		dangerRadiusHit = 60;
		suppressionRadiusHit = 24;
		displayName = "$STR_PGUN_Lemon";
		typicalspeed = 18;
		model = "PortalGun\Obtuse_Attitude_Adjustment_Vegetable_Return\lemon_thrown";
		visibleFire = 0.5;
		audibleFire = 0.05;
		visibleFireTime = 1;
		explosionEffects = "LemonExplosion";
		fuseDistance = 0;
	};
};