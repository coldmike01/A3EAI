private ["_unit","_unitLevel","_weaponSelected","_magazine","_gadgetsArray","_backpack","_gadget","_isRifle"];
_unit = _this select 0;
_unitLevel = _this select 1;

if !(isNil {_unit getVariable "loadout"}) exitWith {diag_log format ["A3EAI Error: Unit already has loadout! (%1)",__FILE__];};

if !(_unitLevel in A3EAI_unitLevelsAll) then {
	_unitLevelInvalid = _unitLevel;
	_unitLevel = A3EAI_unitLevels call BIS_fnc_selectRandom2;
	diag_log format ["A3EAI Error: Invalid unitLevel provided: %1. Generating new unitLevel value: %2. (%3)",_unitLevelInvalid,_unitLevel,__FILE__];
};

_unit call A3EAI_purgeUnitGear;	//Clear unwanted gear from unit first.

_weaponSelected = _unitLevel call A3EAI_getWeapon;
_uniform = (missionNamespace getVariable ["A3EAI_uniformTypes"+str(_unitLevel),A3EAI_uniformTypes3]) call BIS_fnc_selectRandom2;
_backpack = (missionNamespace getVariable ["A3EAI_backpackTypes"+str(_unitLevel),A3EAI_backpackTypes3]) call BIS_fnc_selectRandom2;
_vest = (missionNamespace getVariable ["A3EAI_vestTypes"+str(_unitLevel),A3EAI_vestTypes3]) call BIS_fnc_selectRandom2;
_headgear = (missionNamespace getVariable ["A3EAI_headgearTypes"+str(_unitLevel),A3EAI_headgearTypes3]) call BIS_fnc_selectRandom2;
_magazine = getArray (configFile >> "CfgWeapons" >> _weaponSelected >> "magazines") select 0;

if ((!isNil "_uniform") && {!(_uniform isEqualTo "")}) then {_unit forceAddUniform _uniform;};
if ((!isNil "_backpack") && {!(_backpack isEqualTo "")}) then {_unit addBackpack _backpack; clearAllItemsFromBackpack _unit;};
if ((!isNil "_vest") && {!(_vest isEqualTo "")}) then {_unit addVest _vest;};
if ((!isNil "_headgear") && {!(_headgear isEqualTo "")}) then {_unit addHeadgear _headgear;};
_unit addMagazine _magazine;
_unit addWeapon _weaponSelected;
_unit selectWeapon _weaponSelected;
if ((getNumber (configFile >> "CfgMagazines" >> _magazine >> "count")) < 6) then {_unit addMagazine _magazine};

//Select weapon optics
_isRifle = ((getNumber (configFile >> "CfgWeapons" >> _weaponSelected >> "type")) isEqualTo 1);
if ((missionNamespace getVariable [("A3EAI_opticsChance"+str(_unitLevel)),3]) call A3EAI_chance) then {
	_opticsList = getArray (configFile >> "CfgWeapons" >> _weaponSelected >> "WeaponSlotsInfo" >> "CowsSlot" >> "compatibleItems");
	if !(_opticsList isEqualTo []) then {
		_opticsType = _opticsList call BIS_fnc_selectRandom2;
		if (_isRifle) then {_unit addPrimaryWeaponItem _opticsType} else {_unit addHandGunItem _opticsType};
		//diag_log format ["DEBUG :: Added optics item %1 to unit %2.",_opticsType,_unit];
	};
};

//Select weapon pointer
if ((missionNamespace getVariable [("A3EAI_pointerChance"+str(_unitLevel)),3]) call A3EAI_chance) then {
	_pointersList = getArray (configFile >> "CfgWeapons" >> _weaponSelected >> "WeaponSlotsInfo" >> "PointerSlot" >> "compatibleItems");
	if !(_pointersList isEqualTo []) then {
		_pointerType = _pointersList call BIS_fnc_selectRandom2;
		if (_isRifle) then {_unit addPrimaryWeaponItem _pointerType} else {_unit addHandGunItem _pointerType};
		//diag_log format ["DEBUG :: Added pointer item %1 to unit %2.",_pointerType,_unit];
	};
};

//Select weapon muzzle
if ((missionNamespace getVariable [("A3EAI_muzzleChance"+str(_unitLevel)),3]) call A3EAI_chance) then {
	_muzzlesList = getArray (configFile >> "CfgWeapons" >> _weaponSelected >> "WeaponSlotsInfo" >> "MuzzleSlot" >> "compatibleItems");
	if !(_muzzlesList isEqualTo []) then {
		_muzzleType = _muzzlesList call BIS_fnc_selectRandom2;
		if (_isRifle) then {_unit addPrimaryWeaponItem _muzzleType} else {_unit addHandGunItem _muzzleType};
		//diag_log format ["DEBUG :: Added muzzle item %1 to unit %2.",_muzzleType,_unit];
	};
};

//Select weapon muzzle
if ((missionNamespace getVariable [("A3EAI_underbarrelChance"+str(_unitLevel)),3]) call A3EAI_chance) then {
	_underbarrelList = getArray (configFile >> "CfgWeapons" >> _weaponSelected >> "WeaponSlotsInfo" >> "UnderBarrelSlot" >> "compatibleItems");
	if !(_underbarrelList isEqualTo []) then {
		_underbarrelType = _underbarrelList call BIS_fnc_selectRandom2;
		if (_isRifle) then {_unit addPrimaryWeaponItem _underbarrelType} else {_unit addHandGunItem _underbarrelType};
		//diag_log format ["DEBUG :: Added underbarrel item %1 to unit %2.",_underbarrelType,_unit];
	};
};

_unit setVariable ["loadout",[[_weaponSelected],[_magazine]]];
if (A3EAI_debugLevel > 1) then {diag_log format ["A3EAI Extended Debug: Created loadout for unit %1 (unitLevel: %2): %3.",_unit,_unitLevel,[_uniform,_weaponSelected,_magazine,_backpack,_vest,_headgear]];};

true
