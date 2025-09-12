@icon("res://sprites/IconGodotNode/64x-hidpi/symbols/todo-yellow.png")
## Base class for calculating a utility factor score
## Abstract base for Utility AI "factor" nodes.
##
## A UtilityFactorBase computes a floating-point score via a subclass-defined
## [_calculate_score] and combines it with a constant [member bias] and a
## random component in the range [[member noise_min], [member noise_max]].
## Use this as a building block for Utility AI selectors.
##
## To use, extend this class and override [_calculate_score] to return a
## normalized score (commonly 0..1) based on your context. Call
## [method get_score] to obtain the final value used by the selector.
##
## [b]Example[/b]:
## [codeblock]
## class_name HealthFactor
## extends UtilityFactorBase
##
## var current_health: float
## var max_health: float = 100.0
##
## func _calculate_score() -> float:
##     return clampf(current_health / max_health, 0.0, 1.0)
## [/codeblock]
class_name UtilityFactorBase
extends Node


## Constant value added to the computed score.
## Expected range is -1..1.
@export_range(-1,1) var bias : float = 0.0
## Minimum random noise added to the score (inclusive).
## Automatically keeps [member noise_max] >= [member noise_min]. Range: -1..1.
@export_range(-1, 1) var noise_min: float = 0.0:
	set(value):
		noise_min = value
		if noise_max < value: 
			noise_max = value
## Maximum random noise added to the score (inclusive). Range: -1..1.
@export_range(-1, 1) var noise_max: float = 0.0


## Emitted when [method select] is called.
signal selected

## Returns the final score: [_calculate_score] + [member bias] + random noise.
## [returns] The computed score as a float.
func get_score() -> float:
	var noise := randf_range(noise_min , noise_max)
	var total :float = _calculate_score() + bias + noise
	# print("Factor "+name+" score :: "+str(total))
	return total


## Emits the [signal selected] signal. Helper for selectors.
func select():
	selected.emit()

## Abstract entry point
## Override in subclasses to provide the base score used by [method get_score].
## The default implementation reports an error and returns 0.
## [returns] The base score before bias/noise.
func _calculate_score() -> float:
	push_error("UtilityFactorBase._calculate_score() is abstract. Override in a subclass.")
	return 0


#Helpers

func get_agent() -> TacticalUnit:
	if owner is not TacticalUnit:
		push_warning("Expected owner ["+ owner.name +"] to be [TacticalUnit] ")
		return null
	return owner as TacticalUnit