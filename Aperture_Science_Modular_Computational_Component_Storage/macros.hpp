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

// ------------------ DEBUG OPTIONS ---------------------------

// Uncomment below line for normal debug

#define ASHPD_DEBUG

// Uncomment below line for verbose debug

//#define ASHPD_VERBOSE_DEBUG

// ------------------------------------------------------------

// Debug logging
#define ASHPD_LOG_FUNC(fnc) (diag_log text format [localize "$STR_PGUN_LOG_STR", fnc, _this])
// NOTE: Below macro can't take array for "args", use a #define instead!
#define ASHPD_LOG(str, args) (diag_log text format ([localize str] + args))

// Update rates
#define ASHPD_SP_UPDATE_RATE 144
#define ASHPD_MP_UPDATE_RATE 60

// Constants
#define ASHPD_PORTAL_HEIGHT 2
#define ASHPD_PORTAL_WIDTH 1.2
#define ASHPD_PORTAL_HEIGHT_H 1
#define ASHPD_PORTAL_WIDTH_H 0.6
#define ASHPD_BH_FATAL_DISTANCE 150
#define ASHPD_BH_COOLDOWN 600

// Common macros
#define ASHPD_DISABLED_POS [0,0,0]
#define ASHPD_VAR_BLUE_OPEN (ASHPD_VAR_BLUE_PORTAL getVariable ["open", false])
#define ASHPD_VAR_ORANGE_OPEN (ASHPD_VAR_ORANGE_PORTAL getVariable ["open", false])
#define ASHPD_HIDE_SERVER(obj, hide) ([obj, hide] remoteExecCall ["hideObjectGlobal", [0, 2] select ASHPD_VAR_IS_DEDI])

// Error messages
#define ASHPD_ERROR(msg) ([] spawn {[localize msg, localize "$STR_PGUN_Error_Header", true, false, [] call BIS_fnc_displayMission, false, false] call BIS_fnc_guiMessage})

// Cameras
#define ASHPD_REMOTE_BLUE_CAM (missionNameSpace getVariable [format["ASHPD_VAR_BCAM%1", remoteExecutedOwner], objNull])
#define ASHPD_REMOTE_ORANGE_CAM (missionNameSpace getVariable [format["ASHPD_VAR_OCAM%1", remoteExecutedOwner], objNull])

// Portal gun settings
#define ASHPD_DUAL_PORTALS (ASHPD_VAR_INIT_SETTINGS isEqualTo [true, true])
#define ASHPD_BLUE_ONLY (ASHPD_VAR_INIT_SETTINGS isEqualTo [true, false])
#define ASHPD_ORANGE_ONLY (ASHPD_VAR_INIT_SETTINGS isEqualTo [false, true])

// Crosshair image paths
#define ASHPD_CROSSHAIR_DEFAULT "\a3\ui_f\data\IGUI\Cfg\WeaponCursors\arifle_gs.paa"
#define ASHPD_CROSSHAIR_DUAL_EMPTY "\PortalGun\Aperture_Science_Directional_Assistance_Navigational_Overlay_Correspondant\portal_dual_empty.paa"
#define ASHPD_CROSSHAIR_DUAL_FULL "\PortalGun\Aperture_Science_Directional_Assistance_Navigational_Overlay_Correspondant\portal_dual_full.paa"
#define ASHPD_CROSSHAIR_DUAL_BLUE "\PortalGun\Aperture_Science_Directional_Assistance_Navigational_Overlay_Correspondant\portal_dual_blue.paa"
#define ASHPD_CROSSHAIR_DUAL_ORANGE "\PortalGun\Aperture_Science_Directional_Assistance_Navigational_Overlay_Correspondant\portal_dual_orange.paa"
#define ASHPD_CROSSHAIR_BLUE "\PortalGun\Aperture_Science_Directional_Assistance_Navigational_Overlay_Correspondant\portal_blue_full.paa"
#define ASHPD_CROSSHAIR_BLUE_EMPTY "\PortalGun\Aperture_Science_Directional_Assistance_Navigational_Overlay_Correspondant\portal_blue_empty.paa"
#define ASHPD_CROSSHAIR_ORANGE "\PortalGun\Aperture_Science_Directional_Assistance_Navigational_Overlay_Correspondant\portal_orange_full.paa"
#define ASHPD_CROSSHAIR_ORANGE_EMPTY "\PortalGun\Aperture_Science_Directional_Assistance_Navigational_Overlay_Correspondant\portal_orange_empty.paa"

// Portal texture/material paths
#define ASHPD_BLUE_NOISE_TEX "\PortalGun\Aperture_Science_Woof_Containment_Vessel\noise_blue.paa"
#define ASHPD_ORANGE_NOISE_TEX "\PortalGun\Aperture_Science_Woof_Containment_Vessel\noise_orange.paa"
#define ASHPD_BLUE_NOISE_MAT "\PortalGun\Aperture_Science_Woof_Containment_Vessel\Portalflat_blue.rvmat"
#define ASHPD_ORANGE_NOISE_MAT "\PortalGun\Aperture_Science_Woof_Containment_Vessel\Portalflat_orange.rvmat"

#define ASHPD_BLUE_EDGE_TEX "\PortalGun\Aperture_Science_Woof_Containment_Vessel\beam_portaledge_blue.paa"
#define ASHPD_ORANGE_EDGE_TEX "\PortalGun\Aperture_Science_Woof_Containment_Vessel\beam_portaledge_orange.paa"
#define ASHPD_BLUE_EDGE_MAT "\PortalGun\Aperture_Science_Woof_Containment_Vessel\beam_portaledge_blue.rvmat"
#define ASHPD_ORANGE_EDGE_MAT "\PortalGun\Aperture_Science_Woof_Containment_Vessel\beam_portaledge_orange.rvmat"

#define ASHPD_BLUE_PIP_TEX "#(argb,512,512,1)r2t(piprenderbp%1,1)"
#define ASHPD_ORANGE_PIP_TEX "#(argb,512,512,1)r2t(piprenderop%1,1)"
#define ASHPD_PIP_MAT "\PortalGun\Aperture_Science_Woof_Containment_Vessel\PortalflatPiP.rvmat"

// Camera effects
#define ASHPD_BLUE_PIP_EFFECT ["Internal", "Back", format["piprenderbp%1", remoteExecutedOwner]]
#define ASHPD_ORANGE_PIP_EFFECT ["Internal", "Back", format["piprenderop%1", remoteExecutedOwner]]

// Portal colors (currently unused)
#define ASHPD_BLUE "0, 0.447, 0.823"
#define ASHPD_ORANGE "0.992, 0.510, 0"

// Vital components
#define CAKE_JPG "\PortalGun\cake.jpg"