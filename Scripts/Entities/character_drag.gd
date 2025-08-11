## Click & drag controller for a CharacterBody2D with smoothing and momentum
class_name CharacterDrag
extends Node

@export var character_body: CharacterBody2D
@export var disabled: bool = false

@export_category("Feel")
@export var smoothness_speed: float = 10.0        # higher = snappier follow
@export var smoothing_curve: Curve = Curve.new()  # maps [0..1] -> [0..1]
@export var momentum_damping_per_sec: float = 6.0 # higher = faster stop after release

var _is_dragging := false
var _mouse_offset := Vector2.ZERO
var _velocity := Vector2.ZERO

signal started_dragging(start_position: Vector2)
signal stopped_dragging(end_position: Vector2)
signal while_dragging(current_position: Vector2, delta: float)

func _ready() -> void:
	if not character_body:
		push_error("CharacterDrag: 'character_body' must be assigned.")
		set_physics_process(false)
		return

	# Sensible default curve: linear if empty
	if smoothing_curve.get_point_count() == 0:
		smoothing_curve.add_point(Vector2(0, 0))
		smoothing_curve.add_point(Vector2(1, 1))

func _physics_process(delta: float) -> void:
	if disabled: return
	if not character_body:
		return

	if _is_dragging:
		var mouse_pos := get_viewport().get_mouse_position()
		var target := mouse_pos + _mouse_offset

		# Smooth follow factor in [0..1]
		var base_t := 1.0 - exp(-smoothness_speed * delta)
		base_t = clamp(base_t, 0.0, 1.0)
		var curved_t: float = clamp(smoothing_curve.sample(base_t), 0.0, 1.0)

		var current := character_body.global_position
		var next := current.lerp(target, curved_t)

		_velocity = (next - current) / delta
		character_body.velocity = _velocity
		character_body.move_and_slide()

		while_dragging.emit(character_body.global_position, delta)
	else:
		# Momentum phase: exponential damping per second (frame-rate independent)
		if _velocity.length() > 0.01:
			var damp_factor := exp(-momentum_damping_per_sec * delta)
			_velocity *= damp_factor
			character_body.velocity = _velocity
			character_body.move_and_slide()
		else:
			_velocity = Vector2.ZERO
			character_body.velocity = Vector2.ZERO

func _on_area_2d_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if disabled: return
	if not character_body:
		return

	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			_is_dragging = true
			var mouse_pos := get_viewport().get_mouse_position()
			_mouse_offset = character_body.global_position - mouse_pos
			_velocity = Vector2.ZERO
			emit_signal("started_dragging", character_body.global_position)
			get_viewport().set_input_as_handled()

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if not event.pressed and _is_dragging:
			_is_dragging = false
			emit_signal("stopped_dragging", character_body.global_position)
			get_viewport().set_input_as_handled()
