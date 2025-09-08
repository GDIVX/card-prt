# ProjectileEmitter.gd
class_name ProjectileEmitter
extends Node2D

@export var displacement_radius: float = 10


## Public API:
## fire(projectile: PackedScene, at: Vector2) -> void
## Spawns (or reuses) a Projectile, rotates toward `at`, and emits it.
func fire(projectile: PackedScene, at: Vector2) -> void:
	#TODO: Investiage bug: calling this function n times would instantiate n+1 projectiles. The intended behaviour is to spawn only one at each call

	if projectile == null:
		push_warning("ProjectileEmitter.fire: projectile PackedScene is null.")
		return

	var p: Projectile = projectile.instantiate()

	#signals
	p.connect("enable_state_changed" , _on_projectile_enabled_state_changed)

	# Position & aim

	var dir := at - global_position
	var angle := dir.angle()
	p.global_rotation = angle
	#use polar cords to find the position for the projectile
	var x : float = cos(angle)
	var y: float = sin(angle)
	p.position = Vector2(x,y) * displacement_radius

	add_child(p)
	p.emit()


func _on_projectile_enabled_state_changed(value : bool, projectile: Projectile):
	if not value:
		projectile.queue_free()




