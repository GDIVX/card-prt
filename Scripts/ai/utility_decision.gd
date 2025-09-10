extends Node
class_name UtilityDecision

enum CalculationMethod{
	ADD,
	SUBTRACT,
	MULTIPLY,
	DIVIDE,
	AVERAGE
}

@export var actions : Array[UtilityAction]
 ## This stores the references to any needed variables,
 ## with a [StringName] being used as the key and the value being whatever the context is
@export var context : Dictionary = {}


func _ready() -> void:
	for action in actions:
		action.decision = self
		
		for factor in action.factors:
			factor.decisions = self


func get_best_action() -> UtilityAction:
	var best_action : UtilityAction = actions[0]
	var highest_score : float = 0
	
	for action in actions:
		var action_score : float = action.calculate_utility_score()
		context[action.action_id] = action_score
		
		if action_score > highest_score:
			highest_score = action_score
			best_action = action
	
	return best_action


#Formulas
func calculate_final_score(_calculationMethod : CalculationMethod, _scores : Array[float]) -> float:
	match _calculationMethod:
		CalculationMethod.ADD:
			return calculate_via_add(_scores)
		CalculationMethod.SUBTRACT:
			return calculate_via_subtraction(_scores)
		CalculationMethod.MULTIPLY:
			return calculate_via_multiply(_scores)
		CalculationMethod.DIVIDE:
			return calculate_via_division(_scores)
		CalculationMethod.AVERAGE:
			return calculate_via_average(_scores)
		_:
			print("CALCULATION METHOD INVALID OR NOT SET UP (UtilityAICalculator -> calculate_final_score)")
			return 0


func calculate_via_add(_scores : Array[float]) -> float:
	var total_score : float = _scores[0]
	
	for i in range(1, _scores.size()):
		total_score += _scores[i]
	
	return total_score


func calculate_via_subtraction(_scores : Array[float]) -> float:
	var total_score : float = _scores[0]
	
	for i in range(1, _scores.size()):
		total_score -= _scores[i]
	
	return total_score


func calculate_via_multiply(_scores : Array[float]) -> float:
	var total_score : float = _scores[0]
	
	for i in range(1, _scores.size()):
		total_score *= _scores[i]
	
	return total_score


func calculate_via_division(_scores : Array[float]) -> float:
	var total_score : float = _scores[0]
	
	for i in range(1, _scores.size()):
		if _scores[i] == 0:
			print("Warning: Division by zero encountered in calculate_via_division, skipping zero value at index %d." % i)
			continue
		total_score /= _scores[i]
	
	return total_score


func calculate_via_average(_scores : Array[float]) -> float:
	var total_score : float = _scores[0]
	
	for i in range(1, _scores.size()):
		total_score += _scores[i]
	
	total_score /= _scores.size()
	
	return total_score
