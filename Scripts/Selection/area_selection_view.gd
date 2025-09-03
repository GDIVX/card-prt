class_name CircleSelectionView extends SelectionView

@onready var circle : Circle2D = $Circle2D

func _ready() -> void:
	if _spec.strategy is not ShapeSelection: return
	var shape_select = _spec.strategy as ShapeSelection

	var shape = shape_select.shape
	if not "radius" in shape: return    

	circle.radius = shape_select.shape.radius 
		

func _process(delta: float) -> void:
	var mode : SelectionSpec.SelectionMode = _spec.mode
	match  mode:
		SelectionSpec.SelectionMode.CURSOR:
			global_position = get_global_mouse_position()
		SelectionSpec.SelectionMode.CENTER_ON_CASTER:
			global_position = _context.unit.global_position
		SelectionSpec.SelectionMode.FROM_CASTER_TO_MOUSE:
			global_position = _context.unit.global_position
			var angle := get_global_mouse_position().angle_to(global_position)
			rotate_toward(rotation , angle , delta)
