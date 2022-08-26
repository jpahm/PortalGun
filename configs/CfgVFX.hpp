class CfgCloudlets
{
	class ExploAmmoSmoke;
	class Lemon_trail: ExploAmmoSmoke
	{
		interval = 6.2500003e-005;
		circleRadius = 0;
		circleVelocity[] = { 0,
			0,
			0
		};
		angleVar = 0;
		particleFSLoop = 0;
		particleShape = "\A3\data_f\cl_basic";
		particleFSNtieth = 1;
		particleFSIndex = 0;
		particleFSFrameCount = 1;
		animationName = "";
		particleType = "BillBoard";
		timerPeriod = 1;
		lifeTime = 0.1;
		moveVelocity[] = { 0,
			0,
			0
		};
		rotationVelocity = 0;
		weight = 127.5;
		volume = 0.0099999998;
		rubbing = 9.9999997e-010;
		size[] = { 0.050000001,
			0.050000001,
			0.050000001
		};
		sizeCoef = 3;
		color[] = {
		{ 0,
				0.60000002,
				0.80000001,
				0.34999999 },
			{ 0,
				0.60000002,
				0.80000001,
				0.2 },
			{ 0,
				0.60000002,
				0.80000001,
				0.050000001 }
		};
		colorCoef[] = { 0.2,
			0.60000002,
			0.80000001,
			1.2
		};
		animationSpeed[] = { 0 };
		animationSpeedCoef = 1;
		randomDirectionPeriod = 0;
		randomDirectionIntensity = 0;
		onTimerScript = "";
		beforeDestroyScript = "";
		blockAIVisibility = 0;
		lifeTimeVar = 0;
		rotationVelocityVar = 0;
		sizeVar = 0.02;
		colorVar[] = { 0.2,
			0.1,
			0.2,
			0
		};
		randomDirectionPeriodVar = 0;
		randomDirectionIntensityVar = 0;
		position[] = { 0,
			0,
			0
		};
		positionVar[] = { 0,
			0,
			0
		};
		positionVarConst[] = { 0,
			0,
			0
		};
		moveVelocityVar[] = { 0,
			0,
			0
		};
		moveVelocityVarConst[] = { 0,
			0,
			0
		};
		emissiveColor[] = {
		{ 30,
				0,
				0,
				0 },
			{ 0,
				0,
				0,
				0 }
		};
	};
	class Lemon_flame: Lemon_trail
	{
		interval = "0.0075 *fireInterval + 0.0075";
		circleRadius = 1;
		circleVelocity[] = { 0,
			0,
			0
		};
		particleShape = "\a3\data_f\ParticleEffects\Universal\Universal";
		particleFSNtieth = 16;
		particleFSIndex = 10;
		particleFSFrameCount = 32;
		particleFSLoop = 1;
		angleVar = 1;
		animationName = "";
		particleType = "Billboard";
		timerPeriod = 3;
		lifeTime = 3;
		moveVelocity[] = { 0,
			0.025,
			0
		};
		rotationVelocity = 0;
		weight = 0.075000003;
		volume = 0.050000001;
		rubbing = 0.050000001;
		size[] = { 0.5,
			0.5,
			0.5,
			0.5
		};
		sizeCoef = 3;
		damageType = "Fire";
		coreIntensity = 50;
		coreDistance = 0.5;
		damageTime = 0.1;
		color[] = {
		{ 1,
				1,
				1,
				0.60000002 },
			{ 1,
				1,
				1,
				0.40000001 },
			{ 1,
				1,
				1,
				0.22 },
			{ 1,
				1,
				1,
				0.1 },
			{ 1,
				1,
				1,
				0 }
		};
		colorCoef[] = { 1,
			1,
			1,
			1.2
		};
		animationSpeed[] = { 1.7,
			0.60000002,
			0.40000001,
			0.30000001,
			0.30000001
		};
		randomDirectionPeriod = 0.2;
		randomDirectionIntensity = 0.050000001;
		onTimerScript = "";
		lifeTimeVar = 1.7;
		positionVar[] = { "1 + 1.1 *intensity",
			0.30000001,
			"1 + 1.1 *intensity" };
		moveVelocityVar[] = { 0.1,
			0.1,
			0.1
		};
		rotationVelocityVar = 0;
		sizeVar = 0.050000001;
		colorVar[] = { 0.1,
			0.1,
			0.1,
			0
		};
		randomDirectionPeriodVar = 0;
		randomDirectionIntensityVar = 0;
	};
};

class LemonExplosion
{
	class Light1
	{
		simulation = "light";
		type = "GrenadeExploLight";
		position[] = { 0,
			0,
			0
		};
		intensity = 0.01;
		interval = 1;
		lifeTime = 1;
	};
	class GrenadeExp1
	{
		simulation = "particles";
		type = "GrenadeExp";
		position[] = { 0,
			0,
			0
		};
		intensity = 1;
		interval = 1;
		lifeTime = 0.5;
	};
	class GrenadeSmoke1
	{
		simulation = "particles";
		type = "GrenadeSmoke1";
		position[] = { 0,
			0,
			0
		};
		intensity = 1;
		interval = 1;
		lifeTime = 1;
	};
	class GrenadeBubbles
	{
		simulation = "particles";
		type = "GrenadeBubbles1";
		position[] = { 0,
			0,
			0
		};
		intensity = 1;
		interval = 1;
		lifeTime = 1;
	};
	class MineWater1
	{
		simulation = "particles";
		type = "MineUnderwaterWaterPDM";
		enabled = "distToWater interpolate[-5.0001,-5,-1,1]";
		intensity = 1;
		interval = 1;
		lifeTime = 1;
	};
	class MineWave
	{
		simulation = "particles";
		type = "GrenadeWaveSmall";
		enabled = "(distToWater interpolate[-10.0001,-10,-1,1]) *(distToWater interpolate[0.1,0.10001,-1,1])";
		position[] = { 0,
			0,
			0
		};
		intensity = 1;
		interval = 1;
		lifeTime = 1;
	};
	class Lemon_flame
	{
		simulation = "particles";
		type = "Lemon_flame";
		position[] = { 0,
			0,
			0
		};
		intensity = 1;
		interval = 1;
		lifeTime = 10;
	};
};