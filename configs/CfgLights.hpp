class PgunFired
{
	class Light1
	{
		simulation = "light";
		type = "PortalLightCannon";
		position[] = { 0,
			0,
			0
		};
		intensity = 1;
		interval = 1;
		lifeTime = 0.12;
	};
};

class CfgLights
{
	class PortalLightMed
	{
		diffuse[] = { 0.45,
			0.68,
			1
		};
		color[] = { 0.45,
			0.68,
			1
		};
		ambient[] = { 0,
			0,
			0,
			0
		};
		brightness = 1;
		size = 1;
		intensity = 500;
		drawLight = 0;
		blinking = 0;
		class Attenuation
		{
			start = 0;
			constant = 0;
			linear = 0;
			quadratic = 2;
			hardLimitStart = 300;
			hardLimitEnd = 600;
		};
		position[] = { 0,
			1.8,
			0
		};
	};
	class PortalLightCannon: PortalLightMed
	{
		diffuse[] = { 0.259,
			0.831,
			0.937
		};
		color[] = { 0.259,
			0.831,
			0.937
		};
		ambient[] = { 0,
			0,
			0,
			0
		};
		brightness = 1;
		size = 1;
		intensity = 500;
		drawLight = 0;
		blinking = 0;
		class Attenuation
		{
			start = 0;
			constant = 0;
			linear = 0;
			quadratic = 2;
			hardLimitStart = 300;
			hardLimitEnd = 600;
		};
		position[] = { "positionX + (directionLocalX *1.3)",
			"positionY + (directionLocalY *1.3)",
			"positionZ + (directionLocalZ *1.3)" };
	};
};