## A card effect that apply damage to targets
class_name DealDamageEffect extends CardEffect

## How much damage to apply before modifiers
@export var damage_value : int
## How should the damage be applied on an entity
@export var damage_type : DamageType

enum DamageType{
     ## Unmodified damage. Will try to damage defense, and then health.
    NORMAL,
     ## Ignore defense and applied directly on to health.
     ##[br][b]Hint:[/b] This is very powerful as this can't be mitigated. Use low [member damage_value] to balance.
    PIERCE,
    ## Ignore health and only applied to defense.
    ## [br][b]Hint:[/b] This is generally weaker because it can't kill entities. 
    ## On the other hand, it is safe to use large [member damage_value] with this.
    ## [br][b]Best Use Case:[/b] Defense break to soften a target.
    SUNDER, 
    ## Doubles its value when the target's defense is above 0
    ##[br][b]Hint:[/b] A less extreme way to deal with defense then [constant SUNDER].
    BLUNT, 
    ## Doubles its value when the target's defense is 0
    ##[br][b]Hint:[/b] Use this as a finisher against soft targets. 
    SLASH, 
}

func apply(_card: Card, targets: Array) -> void:
    for target in targets:
        if not target.has_node("Health"): continue
        var health :Health = target.get_node("Health")
        

        match damage_type:
            DamageType.NORMAL:
                var overflow_damage : int = max(damage_value - health.defense , 0)
                health.defense = max(health.defense - damage_value , 0)
                health.current_health = max(health.current_health - overflow_damage , 0)
            DamageType.PIERCE:
                health.current_health = max(health.current_health - damage_value , 0)
            DamageType.SUNDER:
                health.defense = max(health.defense - damage_type , 0)
            DamageType.BLUNT:
                var raw_damage: int = damage_value * 2 if health.defense > 0 else damage_type
                var overflow_damage : int = max(raw_damage - health.defense , 0)
                health.defense = max(health.defense - raw_damage , 0)
                health.current_health = max(health.current_health - overflow_damage , 0)
            DamageType.SLASH:
                var raw_damage: int = damage_value * 2 if health.defense == 0 else damage_type
                var overflow_damage : int = max(raw_damage - health.defense , 0)
                health.defense = max(health.defense - raw_damage , 0)
                health.current_health = max(health.current_health - overflow_damage , 0)
