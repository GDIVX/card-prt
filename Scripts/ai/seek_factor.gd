@icon("res://sprites/IconGodotNode/64x-hidpi/objects/magnifying-glass-yellow.png")
## Utility AI factor that seeks the best child in a domain.
##
## SeekFactor iterates over the direct children of a given domain node and
## computes a score for each one via a subclass-implemented
## [method _score_candidate]. The highest-scoring candidate is cached as the
## [member _best_target] and its score is returned from [method _calculate_score].
##
## Calling [method select] after scoring emits [signal selected_with_context]
## with [member _best_target]. If no candidate was found,
## it falls back to [method UtilityFactorBase.select] and emits the base
## [signal UtilityFactorBase.selected].
##
## To use, extend this class and override [method _score_candidate] to return a
## normalized score for each candidate (commonly 0..1). Return 0.0 for
## invalid/irrelevant candidates so they are ignored.
##
## [b]Example[/b]: choose the closest child as the target
## [codeblock]
## extends SeekFactor
##
## var origin: Node3D
##
## func _score_candidate(candidate: Node) -> float:
##     if candidate is Node3D and origin:
##         var d := origin.global_position.distance_to(candidate.global_position)
##         return 1.0 / (1.0 + d) # Higher score for closer candidates
##     return 0.0
## [/codeblock]
@abstract
class_name SeekFactor
extends UtilityFactorBase

## Path to the domain node whose direct children are evaluated as candidates.
@export var domain_group : StringName

## Emitted when [method select] chooses a best target.
## [param target]: The selected candidate node.
## [param score]: The candidate's computed score.
signal selected_with_context(target: Node)

## Best candidate found during scoring.
var _best_target: Node
## Best score found during scoring.
var _best_score: float = 0.0



## Abstract: subclasses override this to score one candidate.
## Return 0.0 for invalid/irrelevant candidates so they're ignored.
## [param _candidate]: A child of the domain to score.
## [returns] The candidate's normalized score (commonly 0..1).
@abstract func _score_candidate(_candidate: Node) -> float

## Iterates domain children, caches the best candidate and its score.
## [returns] The highest score among evaluated candidates, or 0.0 if none.
func _calculate_score() -> float:
	_best_target = null
	_best_score = 0.0


	for candidate in get_tree().get_nodes_in_group(domain_group):
		var s := _score_candidate(candidate)
		if s > _best_score:
			_best_score = s
			_best_target = candidate

	return _best_score


## Emits [signal selected_with_context] with the best candidate if present,
## otherwise falls back to [method UtilityFactorBase.select].
func select():
	if _best_target:
		selected_with_context.emit(_best_target)
	else:
		super.select()
