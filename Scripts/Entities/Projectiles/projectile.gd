# Projectile.gd (fixed)
@icon("res://Sprites/IconGodotNode/node_2D/icon_bullet.png")
class_name Projectile extends CharacterBody2D

@export var speed_curve: Curve
@export var lifespan := 1.0
@export var disable_on_collision_with_body := true
@export var auto_emit := false  

var speed = 0.0
var direction = Vector2.RIGHT
var _age := 0.0
var enabled = false: set = enable

signal lifespan_timeout(projectile : Projectile)
signal collided(collision: KinematicCollision2D) 
signal enable_state_changed(value : bool , projectile: Projectile)

func _ready() -> void:
	if auto_emit:
		emit()


## Fire the projectile
func emit() -> void:
	direction = Vector2.RIGHT.rotated(global_rotation)
	_age = 0.0

	enable(true)
	await get_tree().create_timer(lifespan).timeout
	await _on_timeout()

func _on_timeout() -> void:
	lifespan_timeout.emit(self)
	enable(false)


func _physics_process(delta: float) -> void:
	if not enabled : return
	_age += delta
	var t := 1.0 if lifespan <= 0.0 else clampf(_age / lifespan, 0.0, 1.0)
	speed = speed_curve.sample(t) if speed_curve else speed
	velocity = direction * speed * delta

	var collision := move_and_collide(velocity)
	if collision:
		collided.emit(collision)
		if disable_on_collision_with_body:
			enable(false)

func enable(value : bool) -> void:
	visible = value
	enabled = value
	enable_state_changed.emit(value, self)

func _on_hit_box_area_entered(_area: Area2D) -> void:
	pass
