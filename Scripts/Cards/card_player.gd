class_name CardPlayer
extends Node

var _card_effects: Array[CardEffect]
var _range: float
var _card_cost: int

func bind_data(effects : Array[CardEffect], targeting_range: float, cost: int) -> void:
    _card_effects = effects
    _range = targeting_range
    _card_cost = cost


func play():
    #TODO: implement target finding 
    for effect: CardEffect in _card_effects:
        effect.apply(self, [])