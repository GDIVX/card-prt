class_name CardPlayer
extends Node

var _card_effects: Array[CardEffectData]
var _range: float
var _card_cost: int

func bind_data(effects : Array[CardEffectData], targeting_range: float, cost: int) -> void:
    _card_effects = effects
    _range = targeting_range
    _card_cost = cost


func play():
    #TODO: implement target finding 
    for effect_data: CardEffectData in _card_effects:
        effect_data.card_effect.apply(self, [], effect_data.params)