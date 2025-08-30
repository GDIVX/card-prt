extends Node2D
class_name SelectionView

var _spec: SelectionSpec
var _context: CardContext

func set_spec(spec: SelectionSpec , context: CardContext) -> void:
    _spec = spec
    _context = context