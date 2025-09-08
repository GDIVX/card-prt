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