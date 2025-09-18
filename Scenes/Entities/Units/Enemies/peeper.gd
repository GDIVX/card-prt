extends TacticalUnit

@export var ai_root : UtilitySelector

func start_turn() -> void:
	super()
	ai_root.select_factor()

	


func _on_flee_selected() -> void:
	print("flee selected :: Replace with implementation")
	end_turn()


func _on_regroup_selected() -> void:
	print("regroup selected :: :: Replace with implementation")
	end_turn()




func _on_move_to_attack_selected_with_steering(steering: Vector2) -> void:
	var movement := steering if steering.length() <= remaining_movement_length \
	else steering.normalized() * remaining_movement_length

	await move_to(movement)
	end_turn()
