class_name SeparationSteering
extends UtilitySteering

@export var team_group : StringName 
@export var separation_radius : float = 84
@export var curve : Curve


func _calculate_steering() -> Vector2:
    var this := get_agent()
    if not this: return Vector2.ZERO

    var sum := Vector2.ZERO
    var radius := maxf(separation_radius , 0.001)

    for agent in get_tree().get_nodes_in_group(team_group):
        if agent == this: continue
        if agent is not Node2D: continue
        
        var to_me :Vector2 = agent.global_position.direction_to(this.global_position)
        var distance :float= agent.global_position.distance_to(this.global_position)

        if distance <= 0.001 or distance > radius: continue

        var normal := clampf(1.0 - (distance/radius), 0.0 , 1.0)
        var sampled := curve.sample(normal)
        sum += to_me.normalized() * sampled

    return sum.normalized() if sum.length() > 1.0 else  sum


