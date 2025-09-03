class_name RaycastSelection extends SelectionStrategy

@export_flags_2d_physics var collision_mask: int

func _select(context: CardContext, spec: SelectionSpec, controller: SelectionController) -> Array:
	# Early-out: no targets requested
	if spec.max_targets == 0:
		return []



	if not context.unit:
		push_error("Context is missing a unit")
		return []
	
	# Create ray, set it up and fire
	var ray := context.unit.raycast
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
	if not is_valid_team:
		controller.stop__selection()
		print("Stopped selection due to invalid team")
		return []
	
	if not _has_required_children(collider as Node, spec.required_nodes):
		controller.stop__selection()
		print("Stopped selection due to failing to find all required nodes")
		return []
	
	return [collider]
	
