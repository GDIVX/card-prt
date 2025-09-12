class_name GroupCohesionFactor
extends UtilityFactorBase

@export var group_path: NodePath = ^"/root/Main/World/Battle/TurnsManager/PlayerGroup"
@export var curve: Curve
@export var soft_scale: float = 200.0  # tunable distance scale (pixels)

func _calculate_score() -> float:
	var group := get_node_or_null(group_path)
	if group == null:
		return 0.0

	# Collect positions of units in the group (Node2D only)
	var positions: Array[Vector2] = []
	for child in group.get_children():
		if child is Node2D:
			positions.append((child as Node2D).global_position)

	var n := positions.size()
	# Degenerate cases: 0 or 1 unit => "perfect cohesion" by definition
	if n < 2:
		return curve.sample(1.0) if curve else 1.0

	# Average pairwise distance (O(n^2), fine for small groups)
	var sum_dist := 0.0
	var pairs := n as float * (n - 1) / 2
	for i in range(n - 1):
		var pi := positions[i]
		for j in range(i + 1, n):
			sum_dist += pi.distance_to(positions[j])
	var avg_dist := sum_dist / float(pairs)

	# Map distance -> closeness in [0,1]:  closeness = scale / (scale + avg_dist)
	var closeness := 0.0
	if soft_scale <= 0.0:
		closeness = 1.0 / (1.0 + avg_dist)  # fallback if scale is nonpositive
	else:
		closeness = soft_scale / (soft_scale + avg_dist)

	return curve.sample(closeness) if curve else closeness
