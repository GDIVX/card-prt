class_name RaycastSelectionView extends SelectionView

@export var line : Line2D
@export var raycast :RayCast2D

func set_spec(spec: SelectionSpec , context: CardContext) -> void:
	super.set_spec(spec, context)

	raycast.add_exception(context.unit)
	raycast.add_exception(context.unit.get_node("Hitbox"))


func _physics_process(_delta: float) -> void:    
	line.points[0] = _context.unit.global_position
	raycast.target_position = get_global_mouse_position()

	if raycast.is_colliding():
		line.points[1] = raycast.get_collision_point()
	else:
		line.points[1] = get_global_mouse_position()
