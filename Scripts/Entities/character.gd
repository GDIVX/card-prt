## A character or pawn that live on the board
@icon("res://Sprites/IconGodotNode/color/icon_character.png")
class_name  TacticalUnit extends CharacterBody2D

@export_category("Nodes")
@export var health : Health
@export var raycast : RayCast2D 

@export_category("ClickAndDragMovement")
@export var pixels_moved_per_movement: float = 450.0
@export var speed : float = 600.0
@export var nav_agent : NavigationAgent2D


func _physics_process(_delta: float) -> void:
	if nav_agent.is_navigation_finished():
		velocity = Vector2.ZERO
		move_and_slide()
		return
	
	var next: Vector2 = nav_agent.get_next_path_position()
	var to_next: Vector2 = next - global_position

	if to_next.length() <= nav_agent.path_desired_distance:
		velocity = Vector2.ZERO
		return
	
	velocity = to_next.normalized() * speed
	move_and_slide()