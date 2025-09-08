class_name GainDefenseEffect extends CardEffect

@export var defense_gained : int = 1 

func apply(_card: Card, targets: Array) -> void:
    for target in targets:
        if not target.has_node("Health"): continue
        var health :Health = target.get_node("Health")

        health.defense += defense_gained

func describe(_context: CardContext) -> DescriptionSpec:
    var spec := DescriptionSpec.new()
    spec.add(DescriptionSpec.text("Gain "))
    spec.add(DescriptionSpec.param("defense", func(_ctx): return defense_gained))
    spec.add(DescriptionSpec.text(" defense."))
    return spec
