class_name FireProjectileEffect extends CardEffect

@export var projectile_scene : PackedScene

func apply(card: Card, targets: Array) -> void:

    var from := card.context.unit.global_position

    for target in targets:
        var emmiter := card.context.unit.projectile_emitter

        var to :Vector2 = target.global_position
        emmiter.fire(projectile_scene , to)
