class_name NearbyUnitsFactor
extends UtilityFactorBase

@export var group_path: NodePath = ^"/root/Main/World/Battle/TurnsManager/PlayerGroup"
@export var curve: Curve

func _calculate_score() -> float:
	var group := get_node_or_null(group_path)
	var agent := get_agent()
	if group == null or agent == null:
		return 0.0

	# Collect unit positions
	var units: Array[Node2D] = []
	for c in group.get_children():
		if c is Node2D:
			units.append(c)
	var n := units.size()
	if n <= 1:
		return curve.sample(1.0) if curve else 1.0

	# k scales with group size (no magic constant)
	var k := maxi(1, int(ceil(sqrt(float(n - 1)))))

	# Precompute positions
	var pos: Array[Vector2] = []
	pos.resize(n)
	for i in n:
		pos[i] = units[i].global_position

	# For each unit, compute mean distance to its k nearest neighbors
	var knn_means: Array[float] = []
	knn_means.resize(n)
	for i in n:
		var di: PackedFloat32Array = []
		di.resize(n - 1)
		var idx := 0
		for j in n:
			if i == j: continue
			di[idx] = pos[i].distance_to(pos[j])
			idx += 1
		di.sort()  # ascending
		var sumk := 0.0
		for t in k:
			sumk += di[t]
		knn_means[i] = sumk / float(k)

	# Robust group baseline = median of k-NN means
	var sorted_means := knn_means.duplicate()
	sorted_means.sort()
	var mid := n >> 1
	var baseline : float = (sorted_means[mid] if (n % 2 == 1) else (0.5 * (sorted_means[mid - 1] + sorted_means[mid])))

	# Agent index and its k-NN mean
	var agent_idx := units.find(agent)
	var agent_mean := knn_means[agent_idx]

	# Scale-free closeness: higher when agent is tighter than typical
	var closeness := clampf(baseline / max(agent_mean, 1e-6), 0.0, 1.0)

	return curve.sample(closeness) if curve else closeness
