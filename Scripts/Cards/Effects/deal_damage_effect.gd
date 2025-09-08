## A card effect that apply damage to targets
class_name DealDamageEffect extends CardEffect

@export var damage : Damage

## Knockback force magnitude
@export var knockback : float



func apply(card: Card, targets: Array) -> void:
    for target in targets:

        #handle knockback
        handle_knockback(target as Node2D, card.context.unit)

        #handle health
        if not target.has_node("Health"): continue

        var health :Health = target.get_node("Health")
        damage.apply_damage(health)
        


func handle_knockback(target : Node2D, from : Node2D) -> void:
    if target == null : return
    if knockback <= 0: return
    if not target.has_node("KnockbackReceiver"): return

    var receiver : KnockbackReceiver = target.get_node("KnockbackReceiver")

    var direction = from.global_position.direction_to(target.global_position)
    var force = direction * knockback
    receiver.force = force

func describe(_context: CardContext) -> DescriptionSpec:
    var spec := DescriptionSpec.new()
    spec.add(DescriptionSpec.text("Deal "))
    spec.add(DescriptionSpec.param("damage", func(_ctx): return damage.damage_value))
    var type_text := ""
    match damage.damage_type:
        Damage.DamageType.NORMAL:
            type_text = ""
        Damage.DamageType.PIERCE:
            type_text = " piercing"
        Damage.DamageType.SUNDER:
            type_text = " sundering"
        Damage.DamageType.BLUNT:
            type_text = " blunt"
        Damage.DamageType.SLASH:
            type_text = " slashing"
        _:
            type_text = ""
    if type_text != "":
        spec.add(DescriptionSpec.text(type_text))
    spec.add(DescriptionSpec.text(" damage"))
    if knockback > 0.0:
        spec.add(DescriptionSpec.text(" and apply knockback"))
    spec.add(DescriptionSpec.text("."))
    return spec
