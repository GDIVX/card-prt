extends Node2D

@export var smoothness_speed: float = 1
@export var smoothing_curve: Curve = Curve.new()
@export var momentum_damping: float = 0.9  # 0.9 = lose 10% speed each frame

var is_selected: bool = false
var mouse_offset: Vector2 = Vector2.ZERO
var velocity: Vector2 = Vector2.ZERO

signal started_dragging
signal stopped_dragging

var root: Node2D

func _ready() -> void:
	root = get_parent()
	if not root:
		push_error("Root node is missing. Please ensure this node is a child of a Node2D.")
	if smoothing_curve.get_point_count() == 0:
		smoothing_curve.add_point(Vector2(0, 0))
		smoothing_curve.add_point(Vector2(1, 1))

func _process(delta: float) -> void:
	if is_selected:
		var mouse_position = get_global_mouse_position()
		var end_position = mouse_position + mouse_offset
		
		var base_t = 1.0 - exp(-smoothness_speed * delta)
		var curved_t = smoothing_curve.sample(base_t)
		
		var new_position = root.position.lerp(end_position, curved_t)
		velocity = (new_position - root.position) / delta  # store movement speed
		root.position = new_position
	else:
		# Apply momentum after release
		if velocity.length() > 0.01:
			root.position += velocity * delta
			velocity *= momentum_damping
		else:
			velocity = Vector2.ZERO

func _on_area_2d_input_event(viewport:Node, event:InputEvent, shape_idx:int) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			is_selected = true
			mouse_offset = root.position - get_global_mouse_position()
			velocity = Vector2.ZERO
			emit_signal("started_dragging")

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if not event.pressed and is_selected:
			is_selected = false
			emit_signal("stopped_dragging")
