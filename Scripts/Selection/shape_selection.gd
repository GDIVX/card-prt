class_name ShapeSelection
extends SelectionStrategy

## A reusable Shape2D resource (e.g., CircleShape2D, RectangleShape2D).
@export var shape: Shape2D
## Physics layers this query can hit.
@export_flags_2d_physics var collision_mask: int

## Override [method SelectionStrategy._select].
## Returns an [Array] of unique nodes that overlap the query shape.
## Moves the shape according to [param spec.mode]:
##  - [param CURSOR]: center on mouse, no rotation.
##  - [param AUTO_AROUND_CASTER]: center on caster, rotate toward mouse.
func _select(context: CardContext, spec: SelectionSpec, _controller: Node) -> Array:
	# Early out: 0 means no targets at all
	if spec.max_targets == 0:
		return []

	var space_state := context.battle.get_world_2d().direct_space_state
	var params := PhysicsShapeQueryParameters2D.new()
	params.shape = shape
	params.collision_mask = collision_mask
	params.collide_with_bodies = true
	params.collide_with_areas = true
	if context.unit:
		params.exclude = [context.unit]

	# Place the shape
	match spec.mode:
		SelectionSpec.SelectionMode.CURSOR:
			params = _follow_mouse(context, params)
		SelectionSpec.SelectionMode.FROM_CASTER_TO_MOUSE:
			params = _center_on_caster_rotated_toward_mouse(context, params)
		_:
			params = _center_on_caster(context, params)

	var raw_hits := space_state.intersect_shape(params, spec.max_targets)

	# De-dup colliders, then apply team mask
	var seen := {}
	var nodes: Array[Node] = []
	for d in raw_hits:
		var n: Node = d.get("collider")
		if n == null or seen.has(n):
			continue
		seen[n] = true
		if SelectionStrategy._matches_team_mask(context.unit, n, spec.team_mask):
			nodes.append(n)

	return nodes



## Center the shape on the global mouse. No rotation.
func _follow_mouse(context: CardContext, params: PhysicsShapeQueryParameters2D) -> PhysicsShapeQueryParameters2D:
	var mouse_pos := context.battle.get_global_mouse_position()
	params.transform = Transform2D(0.0, mouse_pos)
	return params


## Center on caster only (no rotation).
func _center_on_caster(context: CardContext, params: PhysicsShapeQueryParameters2D) -> PhysicsShapeQueryParameters2D:
	var p := context.unit.global_position if context.unit else Vector2.ZERO
	params.transform = Transform2D(0.0, p)
	return params


## Center on caster and rotate shape to face the mouse (useful for cones/rects-as-arcs).
func _center_on_caster_rotated_toward_mouse(context: CardContext, params: PhysicsShapeQueryParameters2D) -> PhysicsShapeQueryParameters2D:
	var p := context.unit.global_position if context.unit else Vector2.ZERO
	var mouse_pos := context.battle.get_global_mouse_position()
	var angle := (mouse_pos - p).angle()
	params.transform = Transform2D(angle, p)
	return params
