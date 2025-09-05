## Handle health and defense of an entity. 
@icon("res://Sprites/IconGodotNode/color/icon_heart.png")
class_name Health
extends Node

@export var max_health: int


var is_dead: bool

signal received_damage(to_health:int, to_defense:int)
signal health_changed(current_value:int)
signal defense_changed(current_value:int)
signal entity_died(node: Node)



var current_health: int:
	set(value):
		
		if value == current_health: return
		current_health = clamp(value , 0 , max_health)
		health_changed.emit(current_health)


		if current_health == 0:
			entity_died.emit(self)


@export var defense: int:
	set(value):
		if value == defense: return
		defense = max(0, value)
		defense_changed.emit(defense)


func _ready() -> void:
	current_health = max_health
	defense_changed.emit(defense)


func deal_damage(to_health: int, to_defense: int) -> void:
	current_health = max(current_health - to_health, 0)
	defense = max(defense - to_defense, 0)
	received_damage.emit(to_health,to_defense)