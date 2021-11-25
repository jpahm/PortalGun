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

/// Description: Handles updating the custom crosshair depending on current portal states.
/// Parameters: None.
///	Return value: None.

if (PG_DUAL_PORTALS) then {
	//	If neither portal open in dual mode, show both colors empty
	if (!PG_VAR_BLUE_SPAWNED && {!PG_VAR_ORANGE_SPAWNED}) then {
		PG_VAR_CROSSHAIR_IMAGE = PG_CROSSHAIR_DUAL_EMPTY;
	} else {
		//	If both portals open in dual mode, show both colors full
		if (PG_VAR_BLUE_SPAWNED && {PG_VAR_ORANGE_SPAWNED}) then {
			PG_VAR_CROSSHAIR_IMAGE = PG_CROSSHAIR_DUAL_FULL;
		//	Else, if only one color open in dual mode, show one color full
		} else {
			if (PG_VAR_BLUE_SPAWNED) then {
				PG_VAR_CROSSHAIR_IMAGE = PG_CROSSHAIR_DUAL_BLUE;
			} else {
				PG_VAR_CROSSHAIR_IMAGE = PG_CROSSHAIR_DUAL_ORANGE;
			};
		};
	};
} else {
	//	If in blue only mode, show both full if blue open
	if (PG_BLUE_ONLY) then {
		if (PG_VAR_BLUE_SPAWNED) then {
			PG_VAR_CROSSHAIR_IMAGE = PG_CROSSHAIR_BLUE;
		} else {
			PG_VAR_CROSSHAIR_IMAGE = PG_CROSSHAIR_BLUE_EMPTY;
		};
	//	Else, if in orange only mode, show both full if orange open
	} else {
		if (PG_VAR_ORANGE_SPAWNED) then {
			PG_VAR_CROSSHAIR_IMAGE = PG_CROSSHAIR_ORANGE;
		} else {
			PG_VAR_CROSSHAIR_IMAGE = PG_CROSSHAIR_ORANGE_EMPTY;
		};
	};
};