// Copyleft Sysroot 2021

//	Quaternion {
//		x: number,
//		y: number,
//		z: number,
//		w: number
//	}

/// Description: Turns a 3d vector into a quaternion.
/// Parameters:
///		PARAMETER		|		EXPECTED INPUT TYPE		|		DESCRIPTION
///
///		Vector			|		Vector3D				|		3D vector to transform into a Quaternion.
///
///	Return value: Quaternion.
SUS_fnc_QFromVec = {
	params[["_vec3", [1, 1, 1], [[]], 3]];
	private _quat = +_vec3;
	_quat pushBack 0;
	_quat;
};

/// Description: Returns the conjugate of a quaternion.
/// Parameters:
///		PARAMETER		|		EXPECTED INPUT TYPE		|		DESCRIPTION
///
///		Quaternion		|		Quaternion				|		Quaternion to get the conjugate of.
///
///	Return value: Quaternion.
SUS_fnc_QConjugate = {
	params[["_quat", [1, 1, 1, 0], [[]], 4]];
	private _outQuat = _quat select [0, 3] apply {-_x};
	_outQuat pushBack _quat#3;
	_outQuat;
};

/// Description: Returns the magnitude of a quaternion.
/// Parameters:
///		PARAMETER		|		EXPECTED INPUT TYPE		|		DESCRIPTION
///
///		Quaternion		|		Quaternion				|		Quaternion to get the magnitude of.
///
///	Return value: Quaternion.
SUS_fnc_QMagnitude = {
	params[["_quat", [1, 1, 1, 0], [[]], 4]];
	private _sum = 0;
	{
		_sum = _sum + _x^2;
	} forEach _quat;
	sqrt(_sum);
};

/// Description: Normalizes a quaternion.
/// Parameters:
///		PARAMETER		|		EXPECTED INPUT TYPE		|		DESCRIPTION
///
///		Quaternion		|		Quaternion				|		Quaternion to normalize.
///
///	Return value: Normalized quaternion.
SUS_fnc_QNormalize = {
	params[["_quat", [1, 1, 1, 0], [[]], 4]];
	private _mag = [_quat] call SUS_fnc_QMagnitude;
	private _outQuat = [0, 0, 0, 0];
	if (_mag > 0) then {
		_outQuat = +_quat;
		_outQuat = _outQuat apply {_x/_mag};
	};
	_outQuat;
};

/// Description: Multiplies 2 quaternions. REMEMBER: Quaternion multiplication is non-commutative, the order in which you multiply matters!
/// Parameters:
///		PARAMETER		|		EXPECTED INPUT TYPE		|		DESCRIPTION
///
///		Quaternion	A	|		Quaternion				|		Base quaternion to multiply.
///		Quaternion	B	|		Quaternion				|		Quaternion to be multiplied with.
///
///	Return value: Multiplied quaternion representing A*B;
SUS_fnc_QMultiply = {
	params[["_q1", [1, 1, 1, 0], [[]], 4], ["_q2", [1, 1, 1, 0], [[]], 4]];
	_q1 params ["_QX1", "_QY1", "_QZ1", "_QW1"];
	_q2 params ["_QX2", "_QY2", "_QZ2", "_QW2"];
	[
		(_QW1 * _QX2) + (_QX1 * _QW2) + (_QY1 * _QZ2) - (_QZ1 * _QY2),
		(_QW1 * _QY2) - (_QX1 * _QZ2) + (_QY1 * _QW2) + (_QZ1 * _QX2),
		(_QW1 * _QZ2) + (_QX1 * _QY2) - (_QY1 * _QX2) + (_QZ1 * _QW2),
		(_QW1 * _QW2) - (_QX1 * _QX2) - (_QY1 * _QY2) - (_QZ1 * _QZ2)
	];
};

/// Description: Divides 2 quaternions.
/// Parameters:
///		PARAMETER		|		EXPECTED INPUT TYPE		|		DESCRIPTION
///
///		Quaternion	A	|		Quaternion				|		Base quaternion.
///		Quaternion	B	|		Quaternion				|		Quaternion to be divided by.
///
///	Return value: Divided quaternion representing A/B;
SUS_fnc_QDivide = {
	params[["_q1", [1, 1, 1, 0], [[]], 4], ["_q2", [1, 1, 1, 0], [[]], 4]];
	[_q1, [_q2] call SUS_fnc_QConjugate] call SUS_fnc_QMultiply;
};

/// Description: Converts an axis and angle to a quaternion.
/// Parameters:
///		PARAMETER		|		EXPECTED INPUT TYPE		|		DESCRIPTION
///
///		Axis			|		Vector3D or Quaternion	|		Axis to apply the angle to.
///		Angle			|		Number					|		Angle to be applied on the axis. Unit is degrees.
///
///	Return value: Quaternion.
SUS_fnc_QFromAngle = {
	params[["_qAxis", [1, 1, 1, 0], [[]], [3, 4]], ["_angle", 0, [0]]];
	if (count _qAxis < 4) then {
		_qAxis = [_qAxis] call SUS_fnc_QFromVec;
	};
	private _sinA = sin(_angle/2);
	private _outQuat = [_qAxis] call SUS_fnc_QNormalize;
	_outQuat = _outQuat apply {_x * _sinA};
	_outQuat set [3, cos(_angle/2)];
	_outQuat;
};

/// Description: Rotates a quaternion by a set number of degrees on an axis.
/// Parameters:
///		PARAMETER		|		EXPECTED INPUT TYPE		|		DESCRIPTION
///
///		Quaternion		|		Quaternion				|		Quaternion to rotate.
///		Axis			|		Vector3D or Quaternion	|		Axis to rotate on.
///		Angle			|		Number					|		Angle to rotate by. Unit is degrees.
///
///	Return value: Rotated quaternion.
SUS_fnc_QRotate = {
	params[["_quat", [1, 1, 1, 0], [[]], 4], ["_axis", [1, 1, 1], [[]], [3, 4]], ["_angle", 0, [0]]];
	private _quatAngle = [_axis, _angle] call SUS_fnc_QFromAngle;
	private _outQuat = [_quatAngle, _quat] call SUS_fnc_QMultiply;
	[_outQuat, _quatAngle] call SUS_fnc_QDivide;
};

/// Description: Rotates a vector by a set number of degrees on an axis using a quaternion.
/// Parameters:
///		PARAMETER		|		EXPECTED INPUT TYPE		|		DESCRIPTION
///
///		Vector			|		Vector3D				|		Vector to rotate.
///		Axis			|		Vector3D or Quaternion	|		Axis to rotate on.
///		Angle			|		Number					|		Angle to rotate by. Unit is degrees.
///
///	Return value: Rotated vector.
SUS_fnc_QRotateVec = {
	params[["_vec", [1, 1, 1], [[]], 3], ["_axis", [1, 1, 1], [[]], [3, 4]], ["_angle", 0, [0]]];
	private _rotatedVec = [[_vec] call SUS_fnc_QFromVec, _axis, _angle] call SUS_fnc_QRotate;
	_rotatedVec deleteAt 3;
	_rotatedVec;
};