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

/// Description: Refreshes the local PiP textures on the specified client.
/// Parameters:
///		PARAMETER		|		EXPECTED INPUT TYPE		|		DESCRIPTION
///
///		clientID		|		Number					|		The client ID of the client to refresh PiP for.
///
///	Return value: None.

#ifdef ASHPD_DEBUG
ASHPD_LOG_FUNC("RefreshPiP");
#endif

params["_clientID"];

// If the portals are linked, refresh their PiP textures on the specified client
if (ASHPD_VAR_PORTALS_LINKED) then {
	private _bPortal = ASHPD_VAR_BLUE_PORTAL;
	private _oPortal = ASHPD_VAR_ORANGE_PORTAL;
	[_bPortal, _oPortal] remoteExecCall ["ASHPD_fnc_UnlinkPortals", _clientID];
	[_bPortal, _oPortal] remoteExecCall ["ASHPD_fnc_LinkPortals", _clientID];
	[
		getPosWorld _bPortal, vectorDir _bPortal, vectorUp _bPortal, 
		getPosWorld _oPortal, vectorDir _oPortal, vectorUp _oPortal
	] remoteExecCall ["ASHPD_fnc_UpdateCams", _clientID];
};