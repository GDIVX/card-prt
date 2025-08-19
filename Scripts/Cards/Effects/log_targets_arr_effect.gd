class_name LogTargetsEffect
extends CardEffect

func apply(_caster, targets: Array) -> void:
    for target in targets:
        print(target.to_string())