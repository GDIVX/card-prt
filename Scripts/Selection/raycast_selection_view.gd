class_name RaycastSelectionView
extends SelectionView

@export var line: Line2D


var raycast: RayCast2D


func set_spec(spec: SelectionSpec, context: CardContext) -> void:
	super.set_spec(spec, context)
	raycast = context.unit.raycast
	raycast.enabled = true


func _physics_process(_delta: float) -> void:

	# Line endpoints

	# Define the ray segment from caster toward mouse, clamped by max_range
	var from := _context.unit.global_position
	var mouse := _context.battle.get_global_mouse_position()
	var dir := mouse - from
	if dir.length() > _spec.max_range:
		dir = dir.normalized() * _spec.max_range
	var to := from + dir

	raycast.global_position = from
	raycast.target_position = raycast.to_local(to)


	line.points[0] = from
	if raycast.is_colliding():
		to = raycast.get_collision_point()
		line.points[1] = to
	else:
		line.points[1] = to
