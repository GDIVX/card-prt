## Print line. Require param "line" of type String
class_name PrintLineEffect
extends CardEffect

func apply(caster, targets: Array, effect_params: Dictionary) -> void:
    if effect_params.has("line"):
        print(effect_params["line"])