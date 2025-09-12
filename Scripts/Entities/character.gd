## A character or pawn that live on the board
@icon("res://Sprites/IconGodotNode/color/icon_character.png")
class_name  TacticalUnit extends CharacterBody2D

@export_category("Nodes")
@export var raycast : RayCast2D 
@export var knockback : KnockbackReceiver
@export var projectile_emitter : ProjectileEmitter
@export var team : Team

@export_category("Movement")
@export var pixels_moved_per_movement: float = 100.0
@export var speed : float = 600.0
@export var nav_agent : NavigationAgent2D
@export var movement_points : ObservableNumber
@export var movement_points_per_turn : int = 6

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

var remaining_movement_length : float :
	get:
		return pixels_moved_per_movement * movement_points.value


func _ready():
	health.entity_died.connect( func (): play_state = PlayState.DEAD)

	nav_agent.target_position = global_position
	velocity = Vector2.ZERO

	movement_points.value_changed.connect(func (p):
		if not play_state == PlayState.ACTIVE: return
		if p <= 0:
			await nav_agent.navigation_finished
			end_turn())
	
	play_state = PlayState.SLEEPING



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


func move_to(end_position: Vector2) -> void:

	if not play_state == PlayState.ACTIVE: return

	velocity = Vector2.ZERO

	var path_len := remaining_movement_length
	if path_len <= 0: return

	# Limit the path to path_len. Still allow the agent to move even if
	# moving to end_position is too far. Instead, find the furthest valid
	# point along the navigation path within path_len and pathfind to it.
	var map: RID = get_world_2d().navigation_map
	var world_path: PackedVector2Array = NavigationServer2D.map_get_path(map, global_position, end_position, true)

	var clamped_target := global_position
	if world_path.size() >= 1:
		# Ensure the path starts at our current position for accumulation.
		if world_path[0] != global_position:
			world_path.insert(0, global_position)

		var acc := 0.0
		for i in range(1, world_path.size()):
			var a := world_path[i - 1]
			var b := world_path[i]
			var seg_len := a.distance_to(b)
			if acc + seg_len <= path_len:
				acc += seg_len
				clamped_target = b
			else:
				var remain := path_len - acc
				var t := 0.0
				if seg_len > 0.0:
					t = clamp(remain / seg_len, 0.0, 1.0)
				clamped_target = a.lerp(b, t)
				break

	end_position = clamped_target

	var used_points :int = max(ceili(global_position.distance_to(end_position) / pixels_moved_per_movement) , 0)
	movement_points.value -= used_points
	nav_agent.target_position = end_position


func _on_navigation_agent_2d_velocity_computed(safe_velocity:Vector2) -> void:
	velocity = safe_velocity
	move_and_slide()


func start_turn() -> void:
	if play_state == PlayState.DEAD: return
	play_state = PlayState.ACTIVE
	movement_points.value = movement_points_per_turn
	turn_started.emit()


func end_turn() -> void:
	if play_state == PlayState.DEAD: return
	play_state = PlayState.SLEEPING
	movement_points.value = 0
	turn_ended.emit()