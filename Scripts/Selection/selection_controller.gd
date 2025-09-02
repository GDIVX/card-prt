## Provide an API to manage selection of units and entities
extends Node2D
class_name SelectionController


signal selection_started
signal selection_completed(results: Array)
signal selection_canceled


var _active := false
var _spec: SelectionSpec
var _context: CardContext
var _repeats_processed :int = 0
var _all_targets :Array = []
var selection_view: Array[Node] = []


func start_selection(context: CardContext, spec: SelectionSpec) -> void:
	_context = context
	_spec = spec
	_repeats_processed = 0
	_spawn_visual()
	get_tree().create_timer(0.1).timeout.connect(func ():
		_active = true
		selection_started.emit()
		)
	
func stop__selection() -> void:
	_cleanup_visual()
	_active = false
	selection_canceled.emit()


func _unhandled_input(event: InputEvent) -> void:
	if !_active: return
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_RIGHT:
		stop__selection()
		get_viewport().set_input_as_handled()
		return

	match _spec.mode:
		SelectionSpec.SelectionMode.CENTER_ON_CASTER:
			_finish_once()  # no input—auto pick immediately
		_:
			#Detect left mouse click
			if event is not InputEventMouseButton: 
				return
			var click_event := event as InputEventMouseButton
			if not click_event.pressed :
				return
			if click_event.button_index != MOUSE_BUTTON_LEFT:
				return

			#handle range
			var mouse_position = get_global_mouse_position()
			if mouse_position.distance_to(_context.unit.global_position) > _spec.max_range:
				return

			_finish_once()
	get_viewport().set_input_as_handled()
	


func _finish_once():
	var targets := _spec.strategy._select(_context, _spec , self)
	if not _active : return
	_all_targets.append_array(targets)
	_repeats_processed += 1

	if _repeats_processed < _spec.repeats:
		if not selection_view.is_empty():
			# Freeze the last view since it is handled 
			var back_view: Node = selection_view.back() as Node
			back_view.set_process(false)
		# Add new view 
		_spawn_visual()
		return

	_cleanup_visual()
	_active = false
	#If the specs ask for a minimum targets count, count a small array as invalid and cancel 
	if targets.size() >= _spec.min_targets:
		selection_completed.emit(_all_targets)
	else:
		selection_canceled.emit()

func _spawn_visual() -> void:
	var instance = _spec.visualScene.instantiate()
	selection_view.append(instance)
	if not instance.has_method("set_spec"): return

	instance.set_spec(_spec, _context)
	add_child(instance)
	
	pass

func _cleanup_visual() -> void:
	for view in selection_view.duplicate():
		view.queue_free()
	selection_view.clear()
