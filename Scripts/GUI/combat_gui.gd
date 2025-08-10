class_name CombatGui extends CanvasLayer

@export var mana_counter: Counter



func _on_game_resources_system_resource_value_changed(key: String, value: int) -> void:
	# set mana value
	if key == "mana":
		mana_counter.set_count(value)
