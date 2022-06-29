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

/// Description: Plays PotatOS dialog and makes her light flicker in sync, if the potatOS portal gun is equipped.
/// Parameters:
///		PARAMETER		|		EXPECTED INPUT TYPE		|		DESCRIPTION
///
///		Sound			|		String					|		The name of the CfgSounds class of the audio to play.
///		Dialog			|		String					|		The text dialog of the sound. Used only for timing purposes. Subtitles are defined in CfgSounds.
///		Delay			|		Number					|		The delay between each character. The lower this is, the faster the "speaking".
///		Pauses			|		Nested arrays			|		An array of arrays in the format [[char, num], ...] where "char" is any character, and num is a number. Whenever character "char" is reached in the dialog, the next delay will be "num" instead of "delay".
///
///	Return value: None.

params[["_sound", "", [""]], ["_dialog", "", [""]], ["_delay", 0.02, [1]], ["_pauses", [[" ", 0.2], [",", 0.5], [".", 0.8], ["?", 0.8]], [[]]]];

// Only play dialog if potatOS not disabled, not already speaking, and equipped
if (
	!PG_VAR_POTATO_ENABLED || 
	{PG_VAR_POTATO_SPEAKING} || 
	{!((currentWeapon player) isEqualTo "ASHPD_MK_SUS_P")}
) exitWith {};

PG_VAR_POTATO_SPEAKING = true;

// Split dialog into chars
private _chars = _dialog splitString "";

// Turn on potato light
player addPrimaryWeaponItem "GeneticLifeFormandDiskOperatingSystem";
private _hasItem = true;

[player, _sound] remoteExecCall ["say3D"];

{
	// Prepare to exit, just in case potato is unequipped mid-speech
	if (!((currentWeapon player) isEqualTo "ASHPD_MK_SUS_P")) exitWith {};
	private _char = _x;
	// Check whether we need to pause on the current character
	private _pauseIndex = _pauses findIf {(_x#0) == _char};
	if (_pauseIndex > -1) then { // We need to pause
		if (_hasItem) then { // If pausing and light is on, turn off light
			player removePrimaryWeaponItem "GeneticLifeFormandDiskOperatingSystem";
			_hasItem = false;
		};
		sleep ((_pauses#_pauseIndex)#1); // Sleep for pause delay
	} else { // We don't need to pause
		if (!_hasItem) then { // If not pausing and light isn't on, turn it on
			player addPrimaryWeaponItem "GeneticLifeFormandDiskOperatingSystem";
			_hasItem = true;
		};
		sleep _delay; // Sleep for standard char delay
	};
	false;
} count _chars;

player removePrimaryWeaponItem "GeneticLifeFormandDiskOperatingSystem"; // Turn off potato light

PG_VAR_POTATO_SPEAKING = false;