##Base class for calculating a utility factor score
class_name UtilityFactor extends Node

var decision : UtilityDecision

##Abstract method to calculate a factor score. Do not call it from [UtilityFactor], override it instead.
func calculate_factor_score() -> float:
	print("WARNING: Called factor calculation from base class which is meant to be overwritten, returns 0 (UtilityFactor -> calculate_factor_score)")
	return 0
