@icon("res://sprites/IconGodotNode/64x-hidpi/2d/double-chevron-right-yellow.png")
@abstract
class_name UtilitySteering
extends UtilityFactorBase

var steering : Vector2
var clamped : Vector2 : 
    get:
        return steering if steering.length() <= 1 else steering.normalized()

signal selected_with_steering(steering: Vector2)

# Factors still play nice with the tree: score = |steering|
func _calculate_score() -> float:
    steering = _calculate_steering()
    return clamped.length()

@abstract
func _calculate_steering() -> Vector2


# When chosen, emit steering context
func select() -> void:
    selected_with_steering.emit(steering)
    selected.emit()  # keep the generic signal too