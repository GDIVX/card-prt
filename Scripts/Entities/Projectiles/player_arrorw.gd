extends Projectile


func _on_hit_box_area_entered(_area: Area2D) -> void:
	enable(false)
