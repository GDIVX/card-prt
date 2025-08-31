class_name RaycastSelection extends SelectionStrategy

@export_flags_2d_physics var collision_mask: int

func _select(context: CardContext, spec: SelectionSpec, _controller: Node) -> Array:
	# Early-out: no targets requested
	if spec.max_targets == 0:
		return []

	var space_state := context.battle.get_world_2d().direct_space_state

	# Define the ray segment from caster toward mouse, clamped by max_range
	var from := context.unit.global_position if context.unit else Vector2.ZERO
	var mouse := context.battle.get_global_mouse_position()
	var dir := mouse - from
	if dir.length() > spec.max_range:
		dir = dir.normalized() * spec.max_range
	var to := from + dir

	var query := PhysicsRayQueryParameters2D.create(from, to)
	query.collision_mask = collision_mask
	query.collide_with_areas = true
	query.collide_with_bodies = true
	# Exclude the caster and a common hitbox child if present (use RIDs for typed exclude)
	if context.unit:
		var ex: Array[RID] = []
		ex.append(context.unit.get_rid())
		var hb := context.unit.get_node_or_null("Hitbox")
		if hb:
			ex.append(hb.get_rid())
		query.exclude = ex

	var hit := space_state.intersect_ray(query)
	if hit.is_empty():
		return []

	var collider: Node = hit.get("collider")
	if collider == null:
		return []

	# Prefer returning a logical target node: climb to a node that has a Team if needed
	var target := collider
	if SelectionStrategy._get_team(target) == null and target.get_parent():
		var p := target.get_parent()
		while p and SelectionStrategy._get_team(p) == null:
			p = p.get_parent()
		if p:
			target = p

	if SelectionStrategy._matches_team_mask(context.unit, target, spec.relation_mask):
		return [target]

	return []
