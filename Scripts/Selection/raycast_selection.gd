class_name RaycastSelection extends SelectionStrategy

@export_flags_2d_physics var collision_mask: int

func _select(context: CardContext, spec: SelectionSpec, controller: SelectionController) -> Array:
	# Early-out: no targets requested
	if spec.max_targets == 0:
		return []

	# Define the ray segment from caster toward mouse, clamped by max_range
	var from := context.unit.global_position if context.unit else Vector2.ZERO
	var mouse := context.battle.get_global_mouse_position()
	var dir := mouse - from
	if dir.length() > spec.max_range:
		dir = dir.normalized() * spec.max_range
	var to := from + dir

	if not context.unit:
		push_error("Context is missing a unit")
		return []
	
	# Create ray, set it up and fire
	var ray := context.unit.raycast
	ray.target_position = to
	ray.collision_mask = collision_mask
	ray.exclude_parent = true
	ray.enabled = true
	ray.force_raycast_update()
	
	if not ray.is_colliding():
		# find nothing
		# Early stop so to not waste the ability
		controller.stop__selection()
		print("Stopped selection early due to no collision")
		return []
	
	var collider := ray.get_collider()
	ray.enabled = false # stop the raycast for performance 

	var is_valid_team = _matches_team_mask(context.unit , collider as Node , spec.relation_mask)
	if is_valid_team:
		return [collider as Node]
	
	# stop the selection - treat this as if you didn't find a target 
	controller.stop__selection()
	print("Stopped selection due to invalid target collision")
	return []
	
