@icon("res://sprites/IconGodotNode/64x-hidpi/2d/double-chevron-right-yellow.png")
class_name SteeringAggregate extends UtilitySteering


enum CombineMethod { SUM, MAX, MIN }

@export var method: CombineMethod = CombineMethod.SUM
@export var normalize_output: bool = true      # normalize final vector
@export var max_magnitude: float = 1.0         # cap after normalize=false (0 => uncapped)

var _factors: Array[UtilitySteering] = []

func _ready() -> void:
	for c in get_children():
		_on_child_entered(c)
	child_entered_tree.connect(_on_child_entered)
	child_exiting_tree.connect(_on_child_exiting)


func _on_child_entered(n: Node) -> void:
	if n is UtilitySteering and not _factors.has(n):
		_factors.append(n)


func _on_child_exiting(n: Node) -> void:
	if n is UtilitySteering:
		_factors.erase(n)


func _calculate_steering() -> Vector2:
	if _factors.is_empty(): 
		return Vector2.ZERO

	match method:
		CombineMethod.SUM:
			var v := Vector2.ZERO
			for f in _factors: v += f._calculate_steering()
			return _finalize(v)

		CombineMethod.MAX:
			var best := Vector2.ZERO
			var best_len := -INF
			for f in _factors:
				var v := f._calculate_steering()
				var L := v.length()
				if L > best_len:
					best_len = L
					best = v
			return _finalize(best)

		CombineMethod.MIN:
			var best := Vector2.ZERO
			var best_len := INF
			for f in _factors:
				var v := f._calculate_steering()
				var L := v.length()
				if L < best_len:
					best_len = L
					best = v
			return _finalize(best)
	
	return Vector2.ZERO


func _finalize(v: Vector2) -> Vector2:
	if normalize_output:
		return v.normalized()
	if max_magnitude > 0.0 and v.length() > max_magnitude:
		return v.normalized() * max_magnitude
	return v


# UtilityFactor contract: score = |steering|
func _calculate_score() -> float:
	steering = _calculate_steering()
	return steering.length()
