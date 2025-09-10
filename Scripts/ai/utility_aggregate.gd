extends UtilityFactor
class_name UtilityAggregate

#region Variables
@export var calculation_method : UtilityDecision.CalculationMethod
@export var factors : Array[UtilityFactor]
#endregion


func calculate_factor_score() -> float:
	return calculate_aggregation_score()


func calculate_aggregation_score() -> float:
	var factor_scores : Array[float] = []
	
	for factor in factors:
		factor_scores.append(factor.calculate_factor_score())
	
	if decision == null:
		push_error("UtilityAggregate: 'decision' is not initialized.")
		return 0.0
	return decision.calculate_final_score(calculation_method, factor_scores)
