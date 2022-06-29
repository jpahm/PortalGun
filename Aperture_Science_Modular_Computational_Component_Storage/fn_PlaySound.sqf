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

/// Description: MP compatibility function for say3D when used on objects that aren't "alive".
/// Parameters:
///		PARAMETER		|		EXPECTED INPUT TYPE		|		DESCRIPTION
///
///		Object			|		Object					|		The source of the sound.
///		Sound			|		String					|		The CfgSounds class of the sound.
///
///	Return value: None.

params[["_object", objNull, [objNull]], ["_sound", "", [""]]]; 

// Create shell object for playing sound
private _dummyObj = "HeliHEmpty" createVehicleLocal [0,0,0]; 
_dummyObj attachTo [_object, [0,0,0]];
_dummyObj say3D _sound;
// Delete the shell object after 5 seconds, should be long enough for all sound effects
uiSleep 5;
deleteVehicle _dummyObj; 