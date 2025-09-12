class_name TurnsManager extends Node

var turn_order :Array[Node] = []

var index :int = 0:
	set(value):
		index = value % turn_order.size()
		

var current: Node :
	get:
		if turn_order.is_empty(): return null
		return turn_order[index]
	

signal turn_started(current : Node)


func _ready():
	turn_order = get_children()



func start_turn():
	if current.has_method("start_turn"):
		current.start_turn()
		turn_started.emit(current)
	
func next_turn():
	index += 1
	start_turn()


func force_turn(turn_index):
	index = turn_index
	start_turn()
