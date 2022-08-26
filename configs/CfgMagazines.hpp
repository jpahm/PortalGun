class CfgMagazines
{
	class CA_Magazine;
	class AS_MBH: CA_Magazine
	{
		author = "Sysroot & Eisenhorn";
		scope = 2;
		displayName = "$STR_PGUN_Portal_Fuse";
		picture = "\PortalGun\ui\Data\Ammo_Icon.paa";
		count = 20;
		ammo = "Portal_Ammo";
		model = "\A3\weapons_f\empty";
		modelSpecial = "A3\weapons_f\empty";
		modelSpecialIsProxy = 1;
		initSpeed = 0.1;
		descriptionShort = "$STR_PGUN_Portal_Fuse_Desc";
		mass = 20;
	};
	class Cylindrical_Baked_Substance_Mag: CA_Magazine
	{
		author = "Sysroot & Eisenhorn";
		scope = 2;
		displayName = "$STR_PGUN_Cake_Bomb";
		picture = "\PortalGun\ui\Data\Cake_Icon.paa";
		model = "PortalGun\Celebratory_Mendacious_Moist_Consolidated_Sustenance\falsehood.p3d";
		descriptionShort = "$STR_PGUN_Cake_Desc";
		class Library
		{
			libTextDesc = "$STR_PGUN_Cake_Desc";
		};
		descriptionUse = "$STR_PGUN_Cake_Desc";
		type = "2*  256";
		allowedSlots[] = { 901 };
		value = 5;
		ammo = "Cylindrical_Baked_Substance_Ammo";
		mass = 80;
		count = 1;
		initSpeed = 0;
		maxLeadSpeed = 0;
		nameSoundWeapon = "satchelcharge";
		nameSound = "satchelcharge";
		weaponPoolAvailable = 1;
		useAction = 1;
		useActionTitle = "$STR_ACTION_PUTBOMB";
		sound[] = { "A3\sounds_f\dummysound",
			0.00031622776,
			1,
			10
		};
	};
	class LemonCombustible: CA_Magazine
	{
		author = "Sysroot & Eisenhorn";
		mass = 10;
		scope = 2;
		value = 1;
		displayName = "$STR_PGUN_Lemon";
		picture = "\PortalGun\ui\Data\Lemon_Icon.paa";
		model = "PortalGun\Obtuse_Attitude_Adjustment_Vegetable_Return\lemon";
		type = 256;
		ammo = "Combustible_Lemon";
		count = 1;
		initSpeed = 18;
		nameSound = "handgrenade";
		maxLeadSpeed = 6.94444;
		descriptionShort = "$STR_PGUN_Lemon_Desc";
		displayNameShort = "$STR_PGUN_Lemon";
	};
};

class CfgMagazineWells
{
	class ASHPD_MBHCU
	{
		Aperture_Science_Magazine[] = { "AS_MBH" };
	};
};