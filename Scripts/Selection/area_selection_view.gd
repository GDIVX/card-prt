class_name AreaSelection extends SelectionView

@onready var circle : Circle2D = $Circle2D

func _ready() -> void:
    circle.radius = _spec.max_range

func _process(_delta: float) -> void:
    var mode : SelectionSpec.SelectionMode = _spec.mode
    match  mode:
        SelectionSpec.SelectionMode.CURSOR:
            global_position = get_global_mouse_position()
        SelectionSpec.SelectionMode.AUTO_AROUND_CASTER:
             global_position = _context.unit.global_position
