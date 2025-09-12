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



func _on_charge_selected() -> void:
	print("charge selected :: :: Replace with implementation")
	end_turn()
