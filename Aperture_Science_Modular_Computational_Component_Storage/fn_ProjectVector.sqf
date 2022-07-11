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

#include "macros.hpp"

#ifdef PG_DEBUG
PG_LOG_FUNC("ProjectVector");
#endif

/// Description: Projects a vector onto a plane defined by a given normal vector.
/// Parameters:
///		PARAMETER		|		EXPECTED INPUT TYPE		|		DESCRIPTION
///
///		vector			|		Vector3D				|		The vector to project.
///		normal			|		Vector3D				|		The normal vector of the plane.
///
///	Return value: A new, restricted vector.

params["_vector", "_normal"];
// Projected vector = normal X (vector X normal)
_normal vectorCrossProduct (_vector vectorCrossProduct _normal);
