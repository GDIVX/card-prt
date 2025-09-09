## A character or pawn that live on the board
@icon("res://Sprites/IconGodotNode/color/icon_character.png")
class_name  TacticalUnit extends CharacterBody2D

@export_category("Nodes")
@export var raycast : RayCast2D 
@export var knockback : KnockbackReceiver
@export var projectile_emitter : ProjectileEmitter
@export var team : Team

@export_category("ClickAndDragMovement")
@export var pixels_moved_per_movement: float = 450.0
@export var speed : float = 600.0
@export var nav_agent : NavigationAgent2D

@export_category("Health")
@export var health : Health

signal turn_started
signal turn_ended


enum PlayState{
	ACTIVE,
	SLEEPING,
	DEAD
}

var play_state : PlayState = PlayState.SLEEPING

func _ready():
	health.entity_died.connect( func (): play_state = PlayState.DEAD)

func _physics_process(_delta: float) -> void:

	if not play_state == PlayState.ACTIVE:
		return

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


func start_turn() -> void:
	if play_state == PlayState.DEAD: return
	play_state = PlayState.ACTIVE
	turn_started.emit()


func end_turn() -> void:
	if play_state == PlayState.DEAD: return
	play_state = PlayState.SLEEPING
	turn_ended.emit()