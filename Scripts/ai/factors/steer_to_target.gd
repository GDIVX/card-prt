class_name SteerToTarget
extends UtilitySteering

@export var seek_unit: SeekUnit
@export var desired_distance: float = 200.0  # arrive radius
@export var curve: Curve                     # expects x in [0,1], y in [0,1]

func _calculate_steering() -> Vector2:
    var agent := get_agent()
    if agent == null or seek_unit == null or seek_unit._best_target == null:
        return Vector2.ZERO

    var unit := seek_unit._best_target as TacticalUnit
    if unit == null:
        return Vector2.ZERO

    var distance := agent.global_position.distance_to(unit.global_position)

    # Map distance -> [0,1] using the arrive radius.
    # 0 when overlapping, 1 when at/ beyond desired_distance.
    var denom := maxf(desired_distance, 0.0001)
    var normalized_distance := clampf(distance / denom, 0.0, 1.0)

    if curve:
        normalized_distance = clampf(curve.sample(normalized_distance), 0.0, 1.0)

    var direction := agent.global_position.direction_to(unit.global_position)
    return direction * distance * normalized_distance
