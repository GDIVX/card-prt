class_name HurtBox extends Area2D

@export var health : Health

func _ready():
    connect("area_entered" , _on_area_entered)


func _on_area_entered(hit_box: HitBox) -> void:
    if not hit_box : return
    hit_box.damage.apply_damage(health)
