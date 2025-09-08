## A character or pawn that live on the board
@icon("res://Sprites/IconGodotNode/color/icon_character.png")
class_name  TacticalUnit extends CharacterBody2D

@export_category("Nodes")
@export var health : Health
@export var raycast : RayCast2D 
@export var knockback : KnockbackReceiver
@export var projectile_emitter : ProjectileEmitter

@export_category("ClickAndDragMovement")
@export var pixels_moved_per_movement: float = 450.0
@export var speed : float = 600.0
@export var nav_agent : NavigationAgent2D




func _physics_process(_delta: float) -> void:

	if health.is_dead: return

	if nav_agent.is_navigation_finished():
		velocity = Vector2.ZERO
		move_and_slide()
		return
	
	var next: Vector2 = nav_agent.get_next_path_position()
	var to_next: Vector2 = next - global_position

	if to_next.length() <= nav_agent.path_desired_distance:
		velocity = Vector2.ZERO
		return
	
	var intended_velocity = to_next.normalized() * speed
	nav_agent.velocity = intended_velocity




func _on_navigation_agent_2d_velocity_computed(safe_velocity:Vector2) -> void:
	velocity = safe_velocity
	move_and_slide()
