class_name UnitsGroup extends Node

@export var faction : Team.Faction

var units : Array[TacticalUnit]
var active_units : Array[TacticalUnit]

signal turn_started
signal turn_ended
signal group_defeated

enum GroupState{
	ACTIVE,
	WAITING,
	DEFEATED
}

var state : GroupState


func _ready() -> void:
	for node in get_children():
		if node is TacticalUnit:
			add_unit(node)

func add_unit(unit : TacticalUnit):
	if units.has(unit): return

	if not get_children().has(unit):
		add_child(unit)
		
	units.append(unit)
	unit.team.faction = faction
	unit.health.entity_died.connect(func (): remove_unit(unit))

	#keep track on units that start and end their turn. End the turn once all units had ended their turn
	unit.turn_started.connect(func (): 
		if active_units.has(unit): return
		active_units.append(unit))
	
	unit.turn_ended.connect(func  ():
		if active_units.has(unit):
			active_units.erase(unit)
		if active_units.size() == 0:
			end_turn())

	



func remove_unit(unit : TacticalUnit):
	if not units.has(unit) : return

	remove_child(unit)
	units.erase(unit)

	if units.size() == 0:
		state = GroupState.DEFEATED
		group_defeated.emit()
		


func start_turn() -> void:

	print("Starting turn for " + name)
	if state == GroupState.DEFEATED or units.size() == 0:
		call_deferred("end_turn")
		return

	state = GroupState.ACTIVE
	turn_started.emit()
	for unit in units:
		unit.start_turn()


func end_turn() -> void:
	state = GroupState.WAITING

	#if the turn was ended early, let all units end their turn
	for unit in units:
		if not unit.play_state == TacticalUnit.PlayState.ACTIVE: continue
		unit.end_turn() 

	turn_ended.emit()

	if get_parent().has_method("next_turn"):
		get_parent().next_turn()
