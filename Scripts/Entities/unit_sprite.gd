class_name UnitSprite
extends AnimatedSprite2D

@export var animation_player: AnimationPlayer
var _is_dead := false

func _ready() -> void:
    animation_finished.connect(_on_sprite_animation_finished)

func _on_applied_damage() -> void:
    if _is_dead: return
    play("hurt_side")
    if animation_player:
        animation_player.play("HIT")

func _on_health_received_damage(_to_health:int, _to_defense:int, health: Health) -> void:
    if health.current_health > 0:
        _on_applied_damage()
    else:
        _on_health_entity_died()

func _on_health_entity_died() -> void:
    _is_dead = true
    play("die_side")

func _on_sprite_animation_finished() -> void:
    if _is_dead: return
    if animation == "hurt_side":
        play("idle_side")
