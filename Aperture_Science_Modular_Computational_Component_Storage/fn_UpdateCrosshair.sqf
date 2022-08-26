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

/// Description: Handles updating the custom crosshair depending on current portal states.
/// Parameters: None.
///	Return value: None.

#ifdef ASHPD_DEBUG
ASHPD_LOG_FUNC("UpdateCrosshair");
#endif

// Don't show custom crosshair if player has it disabled
if !(ASHPD_VAR_CROSSHAIR_ENABLED) exitWith {
	ASHPD_VAR_CROSSHAIR_IMAGE = ASHPD_CROSSHAIR_DEFAULT;
};

if (ASHPD_DUAL_PORTALS) then {
	//	If neither portal open in dual mode, show both colors empty
	if (!ASHPD_VAR_BLUE_OPEN && {!ASHPD_VAR_ORANGE_OPEN}) then {
		ASHPD_VAR_CROSSHAIR_IMAGE = ASHPD_CROSSHAIR_DUAL_EMPTY;
	} else {
		//	If both portals open in dual mode, show both colors full
		if (ASHPD_VAR_BLUE_OPEN && {ASHPD_VAR_ORANGE_OPEN}) then {
			ASHPD_VAR_CROSSHAIR_IMAGE = ASHPD_CROSSHAIR_DUAL_FULL;
		//	Else, if only one color open in dual mode, show one color full
		} else {
			if (ASHPD_VAR_BLUE_OPEN) then {
				ASHPD_VAR_CROSSHAIR_IMAGE = ASHPD_CROSSHAIR_DUAL_BLUE;
			} else {
				ASHPD_VAR_CROSSHAIR_IMAGE = ASHPD_CROSSHAIR_DUAL_ORANGE;
			};
		};
	};
} else {
	//	If in blue only mode, show both full if blue open
	if (ASHPD_BLUE_ONLY) then {
		if (ASHPD_VAR_BLUE_OPEN) then {
			ASHPD_VAR_CROSSHAIR_IMAGE = ASHPD_CROSSHAIR_BLUE;
		} else {
			ASHPD_VAR_CROSSHAIR_IMAGE = ASHPD_CROSSHAIR_BLUE_EMPTY;
		};
	//	Else, if in orange only mode, show both full if orange open
	} else {
		if (ASHPD_VAR_ORANGE_OPEN) then {
			ASHPD_VAR_CROSSHAIR_IMAGE = ASHPD_CROSSHAIR_ORANGE;
		} else {
			ASHPD_VAR_CROSSHAIR_IMAGE = ASHPD_CROSSHAIR_ORANGE_EMPTY;
		};
	};
};