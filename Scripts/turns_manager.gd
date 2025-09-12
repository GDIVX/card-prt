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



func next_turn():
	if current.has_method("start_turn"):
		print("called [start_turn] on " + current.name)
		current.start_turn()
		turn_started.emit(current)

		if current.has_signal("turn_ended"):
			print("waiting for [signal turn_ended]")
			await current.turn_ended
			print("Done waiting")

	# Start the next turn after the current turn had ended
	index += 1
	print("Starting next turn")
	call_deferred("next_turn")
	


func force_turn(turn_index):
	index = turn_index
	next_turn()
