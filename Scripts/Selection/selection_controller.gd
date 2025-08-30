## Provide an API to manage selection of units and entities
extends Node2D
class_name SelectionController


signal selection_started
signal selection_completed(results: Array)
signal selection_canceled


var _active := false
var _spec: SelectionSpec
var _context: CardContext
var selection_view: Node


func start_selection(context: CardContext, spec: SelectionSpec) -> void:
	_context = context
	_spec = spec
	_spawn_visual(spec)
	get_tree().create_timer(0.1).timeout.connect(func ():
		_active = true
		selection_started.emit()
		)
	


func _unhandled_input(event: InputEvent) -> void:
	if !_active: return
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_RIGHT:
		_cleanup_visual()
		_active = false
		selection_canceled.emit()
		get_viewport().set_input_as_handled()
		return

	match _spec.mode:
		SelectionSpec.SelectionMode.CENTER_ON_CASTER:
			_finish_once()  # no input—auto pick immediately
		_:
			if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
				#handle range
				var mouse_position = get_global_mouse_position()
				if mouse_position.distance_to(_context.unit.global_position) > _spec.max_range: return
				_finish_once()
	get_viewport().set_input_as_handled()
	


func _finish_once():
	var targets := _spec.strategy._select(_context, _spec , self)
	_cleanup_visual()
	_active = false
	#If the specs ask for a minimum targets count, count a small array as invalid and cancel 
	if targets.size() >= _spec.min_targets:
		selection_completed.emit(targets)
	else:
		selection_canceled.emit()

func _spawn_visual(spec: SelectionSpec) -> void:
	var instance = spec.visualScene.instantiate()
	if not instance.has_method("set_spec"): return

	instance.set_spec(spec, _context)
	add_child(instance)
	selection_view = instance
	
	pass

func _cleanup_visual() -> void:
	if selection_view and selection_view.is_inside_tree():
		selection_view.queue_free()
	selection_view = null
