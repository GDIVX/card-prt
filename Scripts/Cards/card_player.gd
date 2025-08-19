class_name CardPlayer
extends Node

var _card_effects: Array[CardEffect]

func bind_data(effects : Array[CardEffect]) -> void:
    _card_effects = effects


func play(targets : Array):
    for effect: CardEffect in _card_effects:
        effect.apply(self, targets)


func _resolve() -> void:
    pass
    #TODO