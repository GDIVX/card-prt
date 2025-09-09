class_name PlayerUnit extends TacticalUnit

@export var movement_points : ObservableNumber
@export var movement_points_per_turn : int = 2

var remaining_movement_length : float :
	get:
		return pixels_moved_per_movement * movement_points.value


func _ready() -> void:
	nav_agent.target_position = global_position
	velocity = Vector2.ZERO

	movement_points.value_changed.connect(func (p):
		if not play_state == PlayState.ACTIVE: return
		if p <= 0:
			await nav_agent.navigation_finished
			end_turn())


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
	

func start_turn() -> void:
	super()
	movement_points.value = movement_points_per_turn


func end_turn() -> void:
	super()
	movement_points.value = 0
