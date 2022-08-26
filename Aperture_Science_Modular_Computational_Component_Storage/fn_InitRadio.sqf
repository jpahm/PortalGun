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

/// Description: Handles initializing radio objects.
/// Parameters:
///		PARAMETER		|		EXPECTED INPUT TYPE		|		DESCRIPTION
///
///		Radio			|		Object					|		The radio object being initialized.
///
///	Return value: None.

#ifdef ASHPD_DEBUG
ASHPD_LOG_FUNC("InitRadio");
#endif

params ["_radio"];

_radio addAction [
	localize "$STR_PGUN_Toggle_Radio",
	{ 
		params ["_target", "_caller", "_actionId", "_arguments"];
		private _soundSource = _target getVariable ["soundsource", objNull];
		if (_soundSource isEqualTo objNull) then {
			// No existing sound source, turn radio on
			_soundSource = createSoundSource ["PortalRadioSource", _target, [], 0];
			_soundSource attachTo [_target, [0,0,0]];
			_target setVariable ["soundsource", _soundSource, true];
		} else {
			// Existing sound source, turn radio off
			deleteVehicle _soundSource;
		};
	},
	nil,
	1.5,
	true,
	false,
	"",
	"true",
	2
];