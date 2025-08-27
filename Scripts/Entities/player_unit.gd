class_name PlayerUnit extends TacticalUnit

@export var movement_points : ObservableNumber

@export_category("Editor")
@export var show_movement_distance_limit: bool = true

var _debug_draw_active := false

func _ready() -> void:
	nav_agent.target_position = global_position
	velocity = Vector2.ZERO


func _on_character_drag_started_dragging(_start_position: Vector2) -> void:
	# start_position is already global from your drag signal
	_debug_draw_active = show_movement_distance_limit
	queue_redraw()


func _on_character_drag_stopped_dragging(end_position: Vector2) -> void:
	# Stop showing the ring immediately
	if _debug_draw_active:
		_debug_draw_active = false
		queue_redraw()

	velocity = Vector2.ZERO

	if pixels_moved_per_movement <= 0: return
	if global_position.distance_to(end_position) > pixels_moved_per_movement: return

	nav_agent.target_position = end_position
	movement_points.value -=1
	



	




func _draw() -> void:
	# Only draw when explicitly active (not at game start)
	if not _debug_draw_active or pixels_moved_per_movement <= 0.0:
		return

	var local_center := to_local(global_position)
	draw_arc(local_center, pixels_moved_per_movement, 0.0, TAU, 64, Color.BLUE)


