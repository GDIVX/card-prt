class_name ProximityToUnitsGroupFactor extends UtilityFactor

@export var group_path : NodePath = "/root/Main/World/Battle/TurnsManager/PlayerGroup"
@export var proximity_curve : Curve

func _calculate_score() -> float:
    var group := get_node(group_path)
    var agent = get_agent()

    if not (agent and group): return 0

    var sum : float = 0
    for other_unit in group.get_children():
        if other_unit == agent : continue
        if other_unit is not Node2D: continue
        sum += agent.global_position.distance_to(other_unit.global_position)
    
    var average : float = sum / max(group.get_child_count() - 1, 1)
    var normalized : float = 1.0 / max(average , 0.001)
    return proximity_curve.sample(normalized)
    


