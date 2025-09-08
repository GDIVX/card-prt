# ProjectileEmitter.gd
class_name ProjectileEmitter
extends Node2D

@export var displacement_radius: float = 10


## Public API:
## fire(projectile: PackedScene, at: Vector2) -> void
## Spawns (or reuses) a Projectile, rotates toward `at`, and emits it.

func fire(projectile: Projectile, at: Vector2) -> void:
	if projectile == null:
		push_warning("ProjectileEmitter.fire: projectile is null.")
		return


	#signals
	projectile.connect("enable_state_changed" , _on_projectile_enabled_state_changed)

	# Position & aim

	var dir := at - global_position
	var angle := dir.angle()
	projectile.global_rotation = angle
	#use polar cords to find the position for the projectile
	var x : float = cos(angle)
	var y: float = sin(angle)
	projectile.position = Vector2(x,y) * displacement_radius

	add_child(projectile)
	if not projectile.auto_emit:
		projectile.emit()


func _on_projectile_enabled_state_changed(value : bool, projectile: Projectile):
	if not value:
		projectile.queue_free()



