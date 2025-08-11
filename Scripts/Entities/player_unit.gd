extends CharacterBody2D

@export var movement_distance_limit: float = 0.0

@export_category("Editor")
@export var show_movement_distance_limit: bool = true

var _drag_start_global: Vector2
var _debug_draw_active := false

func _on_character_drag_started_dragging(start_position: Vector2) -> void:
	# start_position is already global from your drag signal
	_drag_start_global = start_position
	_debug_draw_active = show_movement_distance_limit
	queue_redraw()

func _on_character_drag_stopped_dragging(end_position: Vector2) -> void:
	# Stop showing the ring immediately
	if _debug_draw_active:
		_debug_draw_active = false
		queue_redraw()

	# Validate distance and tween back if needed
	if movement_distance_limit > 0.0 \
		and end_position.distance_to(_drag_start_global) >= movement_distance_limit:
		# kill any residual velocity/momentum if you use it
		velocity = Vector2.ZERO

		var tween := get_tree().create_tween()
		tween.tween_property(self, "position", _drag_start_global, 0.5) \
			.set_trans(Tween.TRANS_EXPO) \
			.set_ease(Tween.EASE_IN_OUT)

func _draw() -> void:
	# Only draw when explicitly active (not at game start)
	if not _debug_draw_active or movement_distance_limit <= 0.0:
		return

	# Convert the stored GLOBAL drag start to LOCAL drawing space
	var local_center := to_local(_drag_start_global)

	# Godot 4: use draw_arc for an outline ring
	draw_arc(local_center, movement_distance_limit, 0.0, TAU, 64, Color.BLUE)
