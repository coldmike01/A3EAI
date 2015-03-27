private ["_unitGroup", "_unitLevel", "_trigger", "_unitType", "_groupSize","_patrolParams"];

_unitGroup = _this;

_unitLevel = _unitGroup getVariable ["unitLevel",1];
_unitType = _unitGroup getVariable ["unitType","unknown"];
_groupSize = _unitGroup getVariable ["GroupSize",-1];

_vehicle = assignedVehicle (leader _unitGroup);
_unitGroup setVariable ["assignedVehicle",_vehicle];
(assignedDriver _vehicle) setVariable ["isDriver",true];
_vehicle addEventHandler ["Killed",{[_this,_unitGroup] call A3EAI_heliDestroyed;}];			//Begin despawn process when heli is destroyed.
_vehicle addEventHandler ["GetOut",{[_this,_unitGroup] call A3EAI_heliLanded;}];				//Converts AI crew to ground AI units.
_vehicle addEventHandler ["HandleDamage",{[_this,_unitGroup] call A3EAI_handleDamageHeli}];
_vehicle setVariable ["unitGroup",_unitGroup];
_vehicle call A3EAI_secureVehicle;

if (A3EAI_debugLevel > 1) then {diag_log format ["A3EAI Extended Debug: Group %1 (Level: %2): %3, %4, %5",_unitGroup,_unitLevel,_vehicle,_unitType,_groupSize];};

true