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

#include "macros.hpp"

/// Description: Restricts (negates) a vector along an axis.
/// Parameters:
///		PARAMETER		|		EXPECTED INPUT TYPE		|		DESCRIPTION
///
///		vector			|		Vector3D				|		The vector to restrict.
///		restriction		|		Vector3D				|		The axis to be negated.
///
///	Return value: A new, restricted vector.

params["_vector", "_restriction"];
_vector vectorAdd [
	-(_vector#0) * abs(_restriction#0),
	-(_vector#1) * abs(_restriction#1), 
	-(_vector#2) * abs(_restriction#2)
];
