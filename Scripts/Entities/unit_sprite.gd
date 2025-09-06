class_name UnitSprite extends AnimatedSprite2D

@export var animation_player : AnimationPlayer

func _on_applied_damage() ->void:
    play("hurt_side")
    animation_finished.connect( func () : play("idle_side"))
    animation_player.play("HIT")


func _on_health_received_damage(_to_health:int, _to_defense:int) -> void:
    _on_applied_damage()


func _on_health_entity_died() -> void:
    play("die_side")
