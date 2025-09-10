## Select a factor child with the best score
extends Node
class_name UtilitySelector

var factors : Array


func _ready() -> void:
	for child in get_children():
		_evaluate_child(child)
	
	child_entered_tree.connect(_evaluate_child)
	child_exiting_tree.connect(factors.erase)

	#if a child to a factor, this is a bucket 
	# Call [select_factor] when the parent is selected
	var parent := get_parent()
	if parent is UtilityFactor:
		parent.selected.connect(select_factor)


func _evaluate_child(child : Node):
	if child.has_method("get_score"): factors.append(child)


func select_factor() -> UtilityFactor:
	var best := get_best_factor()
	best.select()
	return best

func get_best_factor() -> UtilityFactor:
	assert(factors.size() > 0)
	var best_action: UtilityFactor = factors[0]
	var highest_score: float = -INF
	for factor in factors:
		var score :float = factor.get_score()
		if score > highest_score:
			highest_score = score
			best_action = factor
	return best_action





