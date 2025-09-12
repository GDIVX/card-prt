@tool
class_name SeekUnit extends SeekFactor

@export var aggression_curve : Curve

@export_category("Vitality")
@export var health_curve : Curve
@export var defense_curve : Curve

@export_category("Position")
@export var distance_curve : Curve
@export var proximity_to_others_curve : Curve



func _score_candidate(candidate: Node) -> float:
    if candidate is not TacticalUnit: return 0

    var unit := candidate as TacticalUnit
    var health_score := _score_health(unit)
    var defense_score := _score_defense(unit)
    var distance_score := _score_defense(unit)
    var pox_score := _score_proximaty(unit)
        
    var product := health_score * defense_score * distance_score * pox_score
    return aggression_curve.sample(product)


func _score_health(unit: TacticalUnit) -> float:
    var normalized := unit.health.normalized()
    return health_curve.sample(normalized)


func _score_defense(unit: TacticalUnit) -> float:
    var defense := unit.health.defense as float
    var best_defense = defense
    for other_unit in _domain.get_children():
        if other_unit == unit : continue
        if other_unit is not TacticalUnit: continue
        var def: float = other_unit.health.defense as float
        best_defense = max(def, best_defense)
    
    var normalized := clampf(defense / best_defense, 0 , 1)
    return defense_curve.sample(normalized)


func _score_distance(unit: TacticalUnit) -> float:
    var agent : Node2D = owner as Node2D
    var distance : float = agent.global_position.distance_to(unit.global_position)
    var normalized: float = 1 / (1 + distance)
    return distance_curve.sample(normalized)


func _score_proximaty(unit: TacticalUnit) -> float:
    var sum : float = 0
    for other_unit in _domain.get_children():
        if other_unit == unit : continue
        if other_unit is not Node2D: continue
        sum += unit.global_position.distance_to(other_unit.global_position)
    
    var average : float = sum / max(_domain.get_child_count() - 1, 1)
    var normalized : float = 1.0 / max(average , 0.001)
    return proximity_to_others_curve.sample(normalized)