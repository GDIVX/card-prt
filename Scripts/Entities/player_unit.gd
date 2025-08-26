class_name PlayerUnit extends TacticalUnit


@export_category("Movement")
@export var movement_distance_limit: float = 0.0
@export var speed : float = 5.0
@export var nav_agent : NavigationAgent2D


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

	if movement_distance_limit <= 0: return
	if global_position.distance_to(end_position) > movement_distance_limit: return

	nav_agent.target_position = end_position
	


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
	




func _draw() -> void:
	# Only draw when explicitly active (not at game start)
	if not _debug_draw_active or movement_distance_limit <= 0.0:
		return

	var local_center := to_local(global_position)
	draw_arc(local_center, movement_distance_limit, 0.0, TAU, 64, Color.BLUE)


