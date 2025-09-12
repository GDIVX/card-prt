extends TacticalUnit

@export var ai_root : UtilitySelector

func start_turn() -> void:
	super()
	ai_root.select_factor()

	
