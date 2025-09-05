class_name UnitSprite extends AnimatedSprite2D

@export var animation_player : AnimationPlayer

func _on_applied_damage() ->void:
    animation_player.play("HIT")


func _on_health_received_damage(_to_health:int, _to_defense:int) -> void:
    _on_applied_damage()
