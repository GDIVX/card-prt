## Aggregates child factor scores into a single utility value.
##
## [UtilityAggregate] is a [UtilityFactorBase] that looks for child nodes
## implementing a `get_score()` method, gathers their scores each frame
## it is queried, and combines them into one value using a selectable
## [enum CalculationMethod]. This allows composing complex AI utility
## values from simpler, reusable factors.
##
## Children can be added or removed at runtime. The node automatically
## tracks children entering and exiting the tree and only considers
## children that implement `get_score()`.
##
## Use [member calculation_method] to choose how scores are combined
## (add, subtract, multiply, divide, average, min, or max).
@tool
extends UtilityFactorBase
class_name UtilityAggregate

#region Variables
## How to combine scores from child factors.
@export var calculation_method : CalculationMethod


var factors : Array

## Supported aggregation operations.
enum CalculationMethod {
	ADD,
	SUBTRACT,
	MULTIPLY,
	DIVIDE,
	AVERAGE,
	MIN,
	MAX,
}

func _ready() -> void:
	for child in get_children():
		_evaluate_child(child)
	
	child_entered_tree.connect(_evaluate_child)
	child_exiting_tree.connect(factors.erase)


## Registers a child node if it exposes `get_score()`.
## @param child: Candidate node to evaluate and possibly track.
func _evaluate_child(child : Node):
	if child.has_method("get_score"): factors.append(child)


## Returns the aggregated score from all tracked factors.
## @return The combined utility score according to [member calculation_method].
func _calculate_score() -> float:
	var scores : Array[float]
	for factor in factors:
		scores.append(factor.get_score())


	return calculate_final_score(calculation_method, scores)


# ---- Math helpers (static: no instance state) ----
## Combines an array of scores using a given method.
static func calculate_final_score(method: CalculationMethod, scores: Array[float]) -> float:
	match method:
		CalculationMethod.ADD:
			return _add(scores)
		CalculationMethod.SUBTRACT:
			return _subtract(scores)
		CalculationMethod.MULTIPLY:
			return _multiply(scores)
		CalculationMethod.DIVIDE:
			return _divide(scores)
		CalculationMethod.AVERAGE:
			return _average(scores)
		CalculationMethod.MIN:
			return _min(scores)
		CalculationMethod.MAX:
			return _max(scores)
		_:
			push_error("Invalid CalculationMethod.")
			return 0.0

static func _sanitize(a: Array[float]) -> Array[float]:
	var out: Array[float] = []
	out.resize(a.size())
	var j := 0
	for i in a.size():
		var v := a[i]
		if is_finite(v):
			out[j] = v
			j += 1
	out.resize(j)
	return out

static func _add(a: Array[float]) -> float:
	a = _sanitize(a)
	var s := 0.0
	for v in a: s += v
	return s

static func _subtract(a: Array[float]) -> float:
	a = _sanitize(a)
	if a.is_empty(): return 0.0
	var s := a[0]
	for i in range(1, a.size()):
		s -= a[i]
	return s

static func _multiply(a: Array[float]) -> float:
	a = _sanitize(a)
	if a.is_empty(): return 0.0
	var p := 1.0
	for v in a: p *= v
	return p

static func _divide(a: Array[float]) -> float:
	a = _sanitize(a)
	if a.is_empty(): return 0.0
	var q := a[0]
	for i in range(1, a.size()):
		var v := a[i]
		if v == 0.0:
			push_warning("Division by zero at index %d; skipping." % i)
			continue
		q /= v
	return q

static func _average(a: Array[float]) -> float:
	a = _sanitize(a)
	if a.is_empty(): return 0.0
	return _add(a) / float(a.size())

static func _min(a: Array[float]) -> float:
	a = _sanitize(a)
	if a.is_empty(): return 0.0
	var m := a[0]
	for i in range(1, a.size()):
		if a[i] < m: m = a[i]
	return m

static func _max(a: Array[float]) -> float:
	a = _sanitize(a)
	if a.is_empty(): return 0.0
	var m := a[0]
	for i in range(1, a.size()):
		if a[i] > m: m = a[i]
	return m
