## Select a [UtilityFactorBase] child with the highest score.
##
## Scans its children for nodes that implement `get_score()` and caches them in
## [member factors]. The cache updates automatically when children enter/exit the
## tree. If this node's parent is a [UtilityFactorBase], the selector behaves like a
## bucket: it connects to the parent's `selected` signal and chooses the best
## factor via [method select_factor].
##
## Use [method get_best_factor] to query the current best factor without
## triggering selection.
@icon("res://sprites/IconGodotNode/64x-hidpi/symbols/question-mark-yellow.png")
class_name UtilitySelector extends Node

@export var print_selection : bool = false

## Cached candidate factors (children implementing `get_score()`).
var factors : Array

signal made_selection(factor : UtilityFactorBase , score : float)

func _ready() -> void:
	for child in get_children():
		_evaluate_child(child)
	
	child_entered_tree.connect(_evaluate_child)
	child_exiting_tree.connect(factors.erase)

	#if a child to a factor, this is a bucket 
	# Call [select_factor] when the parent is selected
	var parent := get_parent()
	if parent is UtilityFactorBase:
		parent.selected.connect(select_factor)


## Adds `child` to [member factors] if it implements `get_score()`.
## Internal helper; not intended for external use.
func _evaluate_child(child : Node):
	if child.has_method("get_score"): factors.append(child)


## Selects the current best factor and returns it.
## - [returns]: The selected [UtilityFactorBase].
func select_factor() -> UtilityFactorBase:
	var best := get_best_factor()
	best.select()

	return best

## Returns the child with the highest `get_score()` without selecting it.
## Asserts that at least one factor exists.
## - [returns]: The best [UtilityFactorBase].
func get_best_factor() -> UtilityFactorBase:
	assert(factors.size() > 0)
	var best_action: UtilityFactorBase = factors[0]
	var highest_score: float = -INF
	for factor in factors:
		var score :float = factor.get_score()
		if score > highest_score:
			highest_score = score
			best_action = factor

	made_selection.emit(best_action , highest_score)
	if print_selection: print("Selected "+best_action.name+" score: "+str(highest_score))

	return best_action
