class_name HurtBox extends Area2D

@export var health : Health
@export var vulnerable : bool = true
@export var invulnerability_duration : float = 0.1

func _ready():
    connect("area_entered" , _on_area_entered)


func _on_area_entered(hit_box: HitBox) -> void:
    if not vulnerable : return
    if not hit_box : return
    hit_box.damage.apply_damage(health)
    # set vulnerable to false for one frame 
    vulnerable = false
    await get_tree().create_timer(invulnerability_duration).timeout
    vulnerable = true
