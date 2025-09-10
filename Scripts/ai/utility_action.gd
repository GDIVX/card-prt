class_name UtilityAction extends Node


@export var action_id : StringName
@export var calculation_method : UtilityDecision.CalculationMethod
@export var factors : Array[UtilityFactor]

var scores : Array[float] = []
var decision : UtilityDecision


func calculate_utility_score() -> float:
    scores.clear()

    for factor in factors:
        scores.append(factor.calculate_factor_score())
    
    return decision.calculate_final_score(calculation_method, scores)