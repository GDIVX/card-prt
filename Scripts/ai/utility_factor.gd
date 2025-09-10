## Base class for calculating a utility factor score
class_name UtilityFactor
extends Node

@export_range(0,1) var bias : float = 0.0

signal selected

func get_score() -> float:
	return _calculate_score() + bias


func select():
	selected.emit()

## Abstract entry point
func _calculate_score() -> float:
	push_error("UtilityFactor._calculate_score() is abstract. Override in a subclass.")
	return bias


