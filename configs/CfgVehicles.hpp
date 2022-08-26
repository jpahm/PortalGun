class CfgVehicles
{
	class Weapon_Base_F;
	class Item_Base_F;
	class NonStrategic;
	class ThingX;
	class item_GeneticLifeFormandDiskOperatingSystem: Item_Base_F
	{
		scope = 0;
		scopeCurator = 0;
		author = "Sysroot & Eisenhorn";
		displayName = "PotatOS";
		vehicleClass = "WeaponAccessories";
		editorCategory = "EdCat_WeaponAttachments";
		editorSubcategory = "EdSubcat_SideSlot";
		model = "\A3\Weapons_f\dummyweapon.p3d";
		class TransportItems
		{
			class PotatOS
			{
				name = "PotatOS";
				count = 1;
			};
		};
	};
	class item_ASHPD_MK_SUS: Weapon_Base_F
	{
		class SimpleObject
		{
			eden = 1;
		};
		scope = 2;
		scopeCurator = 2;
		displayName = "$STR_PGUN_Name_Long";
		author = "Sysroot & Eisenhorn";
		editorCategory = "EdCat_Weapons";
		class TransportWeapons
		{
			class ASHPD_MK_SUS
			{
				weapon = "ASHPD_MK_SUS";
				count = 1;
			};
		};
		class TransportMagazines
		{
			class AS_MBH
			{
				magazine = "AS_MBH";
				count = 1;
			};
		};
	};
	class item_ASHPD_MK_SUS_P: Weapon_Base_F
	{
		class SimpleObject
		{
			eden = 1;
		};
		scope = 2;
		scopeCurator = 2;
		displayName = "$STR_PGUN_Name_P_Long";
		author = "Sysroot & Eisenhorn";
		editorCategory = "EdCat_Weapons";
		class TransportWeapons
		{
			class ASHPD_MK_SUS_P
			{
				weapon = "ASHPD_MK_SUS_P";
				count = 1;
			};
		};
		class TransportMagazines
		{
			class AS_MBH
			{
				magazine = "AS_MBH";
				count = 1;
			};
		};
	};
	class PortalBeams_Base: NonStrategic
	{
		scope = 0;
		scopeCurator = 0;
		model = "PortalGun\Aperture_Science_Trusted_Third_Party_Vendors\PortalBeams.p3d";
		armor = 15;
		icon = "\PortalGun\ui\Data\Portal_Editor_Icon.paa";
		destrType = "DestructNo";
		editorCategory = "EdCat_Things";
		editorSubcategory = "EdCat_Portal";
		accuracy = 1000;
		nameSound = "obj_flag";
		class DestructionEffects {};
		class Attributes {};
		hiddenselections[] = { "bottomfaceg",
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
			"lightningtopl" };
	};
	class PortalBeams: PortalBeams_Base
	{
		author = "Sysroot & Eisenhorn";
		class SimpleObject
		{
			eden = 1;
			animate[] = {};
			hide[] = {};
			verticalOffset = 1.2;
			verticalOffsetWorld = 0;
			init = "''";
		};
		editorPreview = "";
		_generalMacro = "PortalBeams";
		scope = 1;
		scopeCurator = 0;
		displayName = "PortalBeams";
		hiddenselectionstextures[] = { "PortalGun\Aperture_Science_Woof_Containment_Vessel\beamtip.paa",
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
			"PortalGun\Aperture_Science_Woof_Containment_Vessel\beamtemp.paa" };
		class UVAnimations
		{
			class Gun_Lightning_Animation_Base
			{
				type = "translation";
				source = "Gun_Lightning_Source";
				sourceAddress = "loop";
				section = "lightningbottomt";
				minValue = 0;
				maxValue = 1;
				offset0[] = { 0,
					0
				};
				offset1[] = { 0,
					1
				};
			};
			class Gun_Lightning_Animation_BT: Gun_Lightning_Animation_Base
			{
				section = "lightningbottomt";
			};
			class Gun_Lightning_Animation_BR: Gun_Lightning_Animation_Base
			{
				section = "lightningbottomr";
			};
			class Gun_Lightning_Animation_BL: Gun_Lightning_Animation_Base
			{
				section = "lightningbottoml";
			};
			class Gun_Lightning_Animation_TT: Gun_Lightning_Animation_Base
			{
				section = "lightningtopt";
			};
			class Gun_Lightning_Animation_TR: Gun_Lightning_Animation_Base
			{
				section = "lightningtopr";
			};
			class Gun_Lightning_Animation_TL: Gun_Lightning_Animation_Base
			{
				section = "lightningtopl";
			};
			class Gun_Lightning_Ball_Animation_Base
			{
				type = "rotate";
				source = "Gun_Lightning_Ball_Source";
				sourceAddress = "loop";
				section = "bottomfaceg";
				minValue = 0;
				maxValue = 1;
				center[] = { 0.5,
					0.5
				};
				angle0 = 0;
				angle1 = "rad +360";
			};
			class Gun_Lightning_Ball_Animation_BG: Gun_Lightning_Ball_Animation_Base
			{
				section = "bottomfaceg";
			};
			class Gun_Lightning_Ball_Animation_BT: Gun_Lightning_Ball_Animation_Base
			{
				section = "bottomfacet";
			};
			class Gun_Lightning_Ball_Animation_BR: Gun_Lightning_Ball_Animation_Base
			{
				section = "bottomfacer";
			};
			class Gun_Lightning_Ball_Animation_BL: Gun_Lightning_Ball_Animation_Base
			{
				section = "bottomfacel";
			};
			class Gun_Lightning_Ball_Animation_TG: Gun_Lightning_Ball_Animation_Base
			{
				section = "frontfaceg";
			};
			class Gun_Lightning_Ball_Animation_TT: Gun_Lightning_Ball_Animation_Base
			{
				section = "frontfacet";
			};
			class Gun_Lightning_Ball_Animation_TR: Gun_Lightning_Ball_Animation_Base
			{
				section = "frontfacer";
			};
			class Gun_Lightning_Ball_Animation_TL: Gun_Lightning_Ball_Animation_Base
			{
				section = "frontfacel";
			};
		};
		class AnimationSources
		{
			class Gun_Lightning_Source
			{
				source = "user";
				initPhase = 0;
				animPeriod = 1;
			};
			class Gun_Lightning_Ball_Source
			{
				source = "user";
				initPhase = 0;
				animPeriod = 1;
			};
		};
	};
	class Portal_Base: NonStrategic
	{
		scope = 0;
		scopeCurator = 0;
		model = "PortalGun\Aperture_Science_Three_Dimensional_Isomorphic_Volume_Chamber\portal.p3d";
		armor = 15;
		icon = "\PortalGun\ui\Data\Portal_Editor_Icon.paa";
		destrType = "DestructNo";
		editorCategory = "EdCat_Things";
		editorSubcategory = "EdCat_Portal";
		accuracy = 1000;
		nameSound = "obj_flag";
		class DestructionEffects {};
		class Attributes {};
		hiddenselections[] = { "portaledge",
			"portal" };
	};
	class Portal: Portal_Base
	{
		author = "Sysroot & Eisenhorn";
		class SimpleObject
		{
			eden = 1;
			animate[] = {};
			hide[] = {};
			verticalOffset = 1.2;
			verticalOffsetWorld = 0;
			init = "''";
		};
		editorPreview = "";
		_generalMacro = "Portal";
		scope = 2;
		scopeCurator = 2;
		displayName = "$STR_PGUN_Portal";
		hiddenselectionstextures[] = { "#(rgb,8,8,3)color(0,0,0,0.5)",
			"#(rgb,8,8,3)color(0,0,0,1)" };
		class UVAnimations
		{
			class Portal_Flames_Animation
			{
				type = "translation";
				source = "Portal_Flames_Source";
				sourceAddress = "loop";
				section = "portaledge";
				minValue = 0;
				maxValue = 1;
				offset0[] = { 0,
					0
				};
				offset1[] = { 0,
					1
				};
			};
			class Portal_Noise_Animation
			{
				type = "rotate";
				source = "Portal_Noise_Source";
				sourceAddress = "loop";
				section = "portal";
				minValue = 0;
				maxValue = 1;
				center[] = { 0.5,
					0.5
				};
				angle0 = 0;
				angle1 = "rad +360";
			};
			class Portal_Inner_Grow_Animation
			{
				type = "scale";
				source = "Portal_Grow_Source";
				section = "portal";
				minValue = 0;
				maxValue = 1;
				center[] = { 0.5,
					0.5
				};
				scale0[] = { 0,
					0
				};
				scale1[] = { 1,
					1
				};
			};
			class Portal_Outer_Grow_Animation
			{
				type = "scale";
				source = "Portal_Grow_Source";
				section = "portaledge";
				minValue = 0;
				maxValue = 1;
				center[] = { 0.5,
					0.5
				};
				scale0[] = { 0,
					0
				};
				scale1[] = { 1,
					1
				};
			};
		};
		class AnimationSources
		{
			class Portal_Flames_Source
			{
				source = "user";
				initPhase = 0;
				animPeriod = 20;
			};
			class Portal_Noise_Source
			{
				source = "user";
				initPhase = 0;
				animPeriod = 250;
			};
			class Portal_Grow_Source
			{
				source = "user";
				initPhase = 0;
				animPeriod = 0.25;
			};
		};
	};
	class PortalAmbientSource: NonStrategic
	{
		scope = 0;
		sound = "PortalAmbient";
	};
	class GunHoldSource: NonStrategic
	{
		scope = 0;
		sound = "GunHoldLoop";
	};
	class PortalRadioSource: NonStrategic
	{
		scope = 0;
		sound = "PortalRadio";
	};
	class CompanionCubeAmbientSource: NonStrategic
	{
		scope = 0;
		sound = "CompanionCubeAmbient";
	};
	class Weighted_Companion_Cube_Base: ThingX
	{
		scope = 0;
		scopeCurator = 0;
		class SimpleObject
		{
			eden = 1;
			animate[] = {};
			hide[] = {};
			verticalOffset = 0.5;
			verticalOffsetWorld = 0;
			init = "''";
		};
		model = "PortalGun\Esteemed Confidant Euclidean Trigonal Trapezohedron\Weighted_Companion_Cube.p3d";
		hiddenselections[] = { "Weighted_Companion_Cube",
			"The_Cube_Loves_You" };
		armor = 200;
		icon = "\PortalGun\ui\Data\Portal_Editor_Icon.paa";
		destrType = "DestructNo";
		editorCategory = "EdCat_Things";
		editorSubcategory = "EdCat_Portal";
		accuracy = 1000;
		nameSound = "obj_flag";
		class DestructionEffects {};
		class Attributes {};
	};
	class Weighted_Companion_Cube: Weighted_Companion_Cube_Base
	{
		class Eventhandlers
		{
			init = "(createSoundSource[""CompanionCubeAmbientSource"", _this#0, [], 0]) attachTo[_this#0, [0,0,0]];";
		};
		author = "Sysroot & Eisenhorn";
		editorPreview = "";
		_generalMacro = "Weighted Companion Cube";
		scope = 2;
		scopeCurator = 2;
		displayName = "$STR_PGUN_Companion_Cube";
		hiddenselections[] = { "Weighted_Companion_Cube",
			"The_Cube_Loves_You" };
		hiddenSelectionsMaterials[] = { "PortalGun\Esteemed Confidant Euclidean Trigonal Trapezohedron\ApertureScienceWeightedCompanionCube.rvmat",
			"PortalGun\Esteemed Confidant Euclidean Trigonal Trapezohedron\TheCubeLovesYou.rvmat" };
		hiddenSelectionsTextures[] = { "PortalGun\Esteemed Confidant Euclidean Trigonal Trapezohedron\WCC2_co.paa",
			"PortalGun\Esteemed Confidant Euclidean Trigonal Trapezohedron\WCC2_co.paa" };
	};
	class Weighted_Storage_Cube: Weighted_Companion_Cube_Base
	{
		author = "Sysroot & Eisenhorn";
		editorPreview = "";
		_generalMacro = "Weighted Storage Cube";
		scope = 2;
		scopeCurator = 2;
		displayName = "$STR_PGUN_Storage_Cube";
		hiddenselections[] = { "Weighted_Companion_Cube",
			"The_Cube_Loves_You" };
		hiddenSelectionsMaterials[] = { "PortalGun\Esteemed Confidant Euclidean Trigonal Trapezohedron\ApertureScienceWeightedCompanionCube.rvmat",
			"PortalGun\Esteemed Confidant Euclidean Trigonal Trapezohedron\TheCubeDoesntLoveYou.rvmat" };
		hiddenSelectionsTextures[] = { "PortalGun\Esteemed Confidant Euclidean Trigonal Trapezohedron\metal_box.paa",
			"PortalGun\Esteemed Confidant Euclidean Trigonal Trapezohedron\metal_box.paa" };
	};
	class Edge_Less_Safety_Cube_Base: ThingX
	{
		scope = 0;
		scopeCurator = 0;
		class SimpleObject
		{
			eden = 1;
			animate[] = {};
			hide[] = {};
			verticalOffset = 0.5;
			verticalOffsetWorld = 0;
			init = "''";
		};
		model = "PortalGun\Esteemed Confidant Euclidean Trigonal Trapezohedron\Edge_Less_Safety_Cube.p3d";
		hiddenselections[] = { "TheSphereCantTalk",
			"TheSphereDoesntLoveYou" };
		armor = 200;
		icon = "\PortalGun\ui\Data\Portal_Editor_Icon.paa";
		destrType = "DestructNo";
		editorCategory = "EdCat_Things";
		editorSubcategory = "EdCat_Portal";
		accuracy = 1000;
		nameSound = "obj_flag";
		class DestructionEffects {};
		class Attributes {};
	};
	class Edge_Less_Safety_Cube: Edge_Less_Safety_Cube_Base
	{
		author = "Sysroot & Eisenhorn";
		editorPreview = "";
		_generalMacro = "Edgeless Safety Cube";
		scope = 2;
		scopeCurator = 2;
		displayName = "$STR_PGUN_Edgeless_Cube";
		hiddenselections[] = { "Weighted_Companion_Cube",
			"The_Cube_Loves_You" };
		hiddenSelectionsMaterials[] = { "portalgun\esteemed confidant euclidean trigonal trapezohedron\thespheredoesntloveyou.rvmat",
			"portalgun\esteemed confidant euclidean trigonal trapezohedron\thespherestilldoesntloveyou.rvmat" };
		hiddenSelectionsTextures[] = { "PortalGun\Esteemed Confidant Euclidean Trigonal Trapezohedron\MP_ball_1.paa",
			"PortalGun\Esteemed Confidant Euclidean Trigonal Trapezohedron\MP_ball_1.paa" };
	};
	class Pernicious_Sponge_Base: ThingX
	{
		scope = 0;
		scopeCurator = 0;
		class SimpleObject
		{
			eden = 1;
			animate[] = {};
			hide[] = {};
			verticalOffset = 0.5;
			verticalOffsetWorld = 0;
			init = "''";
		};
		model = "PortalGun\Celebratory_Mendacious_Moist_Consolidated_Sustenance\falsehood.p3d";
		hiddenselections[] = { "Deception" };
		armor = 200;
		icon = "\PortalGun\ui\Data\Portal_Editor_Icon.paa";
		destrType = "DestructNo";
		editorCategory = "EdCat_Things";
		editorSubcategory = "EdCat_Portal";
		accuracy = 1000;
		nameSound = "obj_flag";
		class DestructionEffects {};
		class Attributes {};
	};
	class Pernicious_Sponge: Pernicious_Sponge_Base
	{
		author = "Sysroot & Eisenhorn";
		editorPreview = "";
		_generalMacro = "Cake";
		scope = 2;
		scopeCurator = 2;
		displayName = "$STR_PGUN_Cake";
	};
	class ApertureScienceAcousticJoviationDevice_Base: ThingX
	{
		scope = 0;
		scopeCurator = 0;
		class SimpleObject
		{
			eden = 1;
			animate[] = {};
			hide[] = {};
			verticalOffset = 0.5;
			verticalOffsetWorld = 0;
			init = "''";
		};
		model = "PortalGun\Aperture_Science_Acoustic_Joviation_Device\ApertureScienceAcousticJoviationDevice.p3d";
		hiddenselections[] = { "glowface2" };
		armor = 200;
		icon = "\PortalGun\ui\Data\Portal_Editor_Icon.paa";
		destrType = "DestructNo";
		editorCategory = "EdCat_Things";
		editorSubcategory = "EdCat_Portal";
		accuracy = 1000;
		class DestructionEffects {};
		class Attributes {};
	};
	class ApertureScienceAcousticJoviationDevice: ApertureScienceAcousticJoviationDevice_Base
	{
		class Eventhandlers
		{
			init = "[_this#0] call ASHPD_fnc_InitRadio;";
		};
		author = "Sysroot & Eisenhorn";
		editorPreview = "";
		_generalMacro = "Radio";
		scope = 2;
		scopeCurator = 2;
		displayName = "$STR_PGUN_Radio";
	};
	class MineBase;
	class Cylindrical_Baked_Substance: MineBase
	{
		author = "Sysroot & Eisenhorn";
		mapSize = 0.43;
		icon = "iconExplosiveGP";
		editorPreview = "";
		_generalMacro = "Cake Bomb";
		scope = 2;
		scopeCurator = 2;
		editorCategory = "EdCat_Things";
		editorSubcategory = "EdCat_Portal";
		ammo = "Cylindrical_Baked_Substance_Ammo";
		model = "PortalGun\Celebratory_Mendacious_Moist_Consolidated_Sustenance\falsehood.p3d";
		displayName = "$STR_PGUN_Cake_Bomb";
		DLC = "Curator";
	};
	class death_base: NonStrategic
	{
		scope = 0;
		scopeCurator = 0;
		model = "PortalGun\Aperture_Science_Three_Dimensional_Isomorphic_Volume_Chamber\death\death.p3d";
		armor = 15;
		icon = "\PortalGun\ui\Data\Portal_Editor_Icon.paa";
		destrType = "DestructNo";
		editorCategory = "EdCat_Things";
		editorSubcategory = "EdCat_Portal";
		accuracy = 1000;
		nameSound = "obj_flag";
		class DestructionEffects {};
		class Attributes {};
		hiddenselections[] = { "back",
			"front",
			"backbottom",
			"frontbottom" };
	};
	class death: death_base
	{
		class Eventhandlers
		{
			init = "(_this#0) animateSource [""Singularity_Disc_Source"", 1000000, 1];";
		};
		author = "Sysroot & Eisenhorn";
		editorPreview = "";
		_generalMacro = "Singularity";
		scope = 2;
		scopeCurator = 2;
		displayName = "$STR_PGUN_Singularity";
		hiddenselectionstextures[] = { "PortalGun\Aperture_Science_Woof_Containment_Vessel\accretion_disc.paa",
			"PortalGun\Aperture_Science_Woof_Containment_Vessel\accretion_disc.paa",
			"PortalGun\Aperture_Science_Woof_Containment_Vessel\accretion_disc.paa",
			"PortalGun\Aperture_Science_Woof_Containment_Vessel\accretion_disc.paa" };
		class UVAnimations
		{
			class Singularity_Disc_Animation_Back
			{
				type = "translation";
				source = "Singularity_Disc_Source";
				sourceAddress = "loop";
				section = "back";
				minValue = 0;
				maxValue = 1;
				offset0[] = { 0,
					0
				};
				offset1[] = { 1,
					0
				};
			};
			class Singularity_Disc_Animation_Front: Singularity_Disc_Animation_Back
			{
				section = "front";
			};
			class Singularity_Disc_Animation_BackBottom: Singularity_Disc_Animation_Back
			{
				section = "backbottom";
			};
			class Singularity_Disc_Animation_FrontBottom: Singularity_Disc_Animation_Back
			{
				section = "frontbottom";
			};
		};
		class AnimationSources
		{
			class Singularity_Disc_Source
			{
				source = "user";
				initPhase = 0;
				animPeriod = 10;
			};
		};
	};
};