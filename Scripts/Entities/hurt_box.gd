class_name HurtBox extends Area2D

@export var health : Health
@export var vulnerable : bool = true

func _ready():
    connect("area_entered" , _on_area_entered)


func _on_area_entered(hit_box: HitBox) -> void:
    if not vulnerable : return
    if not hit_box : return
    hit_box.damage.apply_damage(health)
    # set vulnerable to false to one frame 
    vulnerable = false
    await get_tree().create_timer(0.1).timeout
    vulnerable = true
