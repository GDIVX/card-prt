## Base class to calculate a consideration factor. 
##
## Extends [UtilityFactor] and provide access to context and evaluation via a [Curve]
class_name UtilityConsideration extends UtilityFactor

@export var context_id : StringName
@export var curve : Curve


## Calculate the utility factor score 
func calculate_factor_score() -> float:
	return calculate_consideration_score()


## Abstract method to calculate consideration score given context and a [member curve]
func calculate_consideration_score() -> float:
	print("WARNING: Called consideration calculation from base class which is meant to be overwritten, returns 0 (UtilityConsideration -> calculate_consideration_score)")
	return 0 