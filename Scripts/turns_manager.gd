class_name TurnsManager extends Node

var turn_order :Array[Node] = []

var index :int = 0:
	set(value):
		index = value % turn_order.size()
		

var current: Node :
	get:
		if turn_order.is_empty(): return null
		return turn_order[index]

func _ready():
	turn_order = get_children()



func next_turn():
	if current.has_method("start_turn"):
		current.start_turn()
	
	if current.has_signal("turn_ended"):
		await current.turn_ended

	index += 1
	# Start the next turn after the current turn had ended
	call_deferred("next_turn")
	

func force_turn(turn_index):
	index = turn_index
	next_turn()
