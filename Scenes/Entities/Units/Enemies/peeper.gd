extends TacticalUnit

@export var ai_root : UtilitySelector

func start_turn() -> void:
	super()
	ai_root.select_factor()

	


func _on_flee_selected() -> void:
	pass # Replace with function body.


func _on_regroup_selected() -> void:
	pass # Replace with function body.


func _on_charge_selected() -> void:
	pass # Replace with function body.
