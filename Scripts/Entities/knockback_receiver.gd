class_name KnockbackReceiver extends Node2D

@export var body : PhysicsBody2D

@export_range(0,1) var damping : float = 0.15
@export var force_multiplier : float = 1

var force : Vector2 = Vector2.ZERO


func _physics_process(delta):

    if force.is_equal_approx(Vector2.ZERO): return

    body.move_and_collide(force * delta * force_multiplier)
    force = force - (force * damping)
