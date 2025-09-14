class_name UtilitySteering
extends UtilityFactorBase


var steering : Vector2

# Factors still play nice with the tree: score = |steering|
func _calculate_score() -> float:
    steering = _calculate_steering()
    return steering.length()

# Abstract
func _calculate_steering() -> Vector2:
    push_error("UtilitySteering._calculate_steering() is abstract. Override in a subclass.")
    return Vector2.ZERO