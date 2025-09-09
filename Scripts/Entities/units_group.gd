class_name UnitsGroup extends Node

@export var faction : Team.Faction

var units : Array[TacticalUnit]


func add_unit(unit : TacticalUnit):
    if units.has(unit): return

    units.append(unit)
    unit.team.faction = faction
    unit.health.entity_died.connect(func (): remove_unit(unit))


func remove_unit(unit : TacticalUnit):
    if not units.has(unit) : return

    units.erase(unit)


