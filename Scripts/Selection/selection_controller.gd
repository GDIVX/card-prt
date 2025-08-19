extends Node2D
class_name SelectionController

signal selection_completed(results: Array)
signal selection_canceled


var _active := false
var _spec: SelectionSpec
var _context: CardContext
var _pending_visual: Node


func start_selection(context: CardContext, spec: SelectionSpec) -> void:
    _context = context
    _spec = spec
    _active = true
    _spawn_visual(spec)


func _unhandled_input(event: InputEvent) -> void:
    if !_active: return
    if event.is_action_pressed("ui_cancel"):
        _cleanup_visual()
        _active = false
        selection_canceled.emit()
        return

    match _spec.mode:
        SelectionSpec.SelectionMode.CURSOR:
            if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
                _finish_once()
        SelectionSpec.SelectionMode.AUTO_AROUND_CASTER:
            _finish_once()  # no input—auto pick immediately


func _finish_once():
    var targets := _spec.strategy._select(_context, _spec , self)
    _cleanup_visual()
    _active = false
    selection_completed.emit(targets)

func _spawn_visual(spec: SelectionSpec) -> void:
    var instance = spec.visualScene.instantiate()
    if not instance.has_method("SetSpec"): return


    instance.set_spec(spec)
    add_child(instance)
    _pending_visual = instance
    
    pass

func _cleanup_visual() -> void:
    if _pending_visual and _pending_visual.is_inside_tree():
        _pending_visual.queue_free()
    _pending_visual = null