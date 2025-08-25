## Click & drag controller for a CharacterBody2D with smoothing and momentum
class_name DragHandle
extends Node

@export var _handle : Node2D
@export var disabled: bool = false

@export_category("Feel")
@export var smoothness_speed: float = 10.0        # higher = snappier follow
@export var smoothing_curve: Curve = Curve.new()  # maps [0..1] -> [0..1]

var _is_dragging := false

signal started_dragging(start_position: Vector2)
signal stopped_dragging(end_position: Vector2)
signal while_dragging(current_position: Vector2, delta: float)

func _ready() -> void:
	_handle.visible = false


func _process(delta: float) -> void:
	if disabled: return
	if not _handle:
		return

	if _is_dragging:

		# Smooth follow factor in [0..1]
		var base_t := smoothness_speed * delta
		var curved_t: float = smoothing_curve.sample(base_t)

		var current := _handle.global_position
		var mouse_pos := _handle.get_global_mouse_position()
		var next := current.lerp(mouse_pos, curved_t)

		_handle.global_position = next
		while_dragging.emit(_handle.position)


func _on_area_2d_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if disabled: return
	if not _handle: return

	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			_handle.position = Vector2.ZERO
			emit_signal("started_dragging", _handle.position)
			_handle.visible = true
			_is_dragging = true
			get_viewport().set_input_as_handled()


func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if not event.pressed and _is_dragging:
			_is_dragging = false
			emit_signal("stopped_dragging", _handle.position)
			_handle.visible = false
			get_viewport().set_input_as_handled()
