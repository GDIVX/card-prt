## A manager class to hold and manage in game resources 
class_name GameResourcesSystem extends Node

@export var resources: Dictionary[String, int]

#signals
signal resource_value_changed(key: String,value: int)

func _ready() -> void:
	#notify about any exported resource to set up its starting value
	for key in resources:
		var value = resources[key]
		resource_value_changed.emit(key,value)

# Helper functions for simple access

func get_resource(key: String) -> int:
	if not resources.has(key): return 0
	return resources[key]

func set_resource(key: String, value: int) -> void:
	resources[key] = value
	resource_value_changed.emit(key,value)

func add_resource(key: String, value: int) -> void:
	if not resources.has(key):
		set_resource(key, value)
		return
		
	resources[key] += value
	resource_value_changed.emit(key, resources[key])
