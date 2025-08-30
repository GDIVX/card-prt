class_name ShapeSelection extends SelectionStrategy

@export var shape : Shape2D
@export_flags_2d_physics var collision_mask : int



func _select(context: CardContext, spec: SelectionSpec, _controller: Node) -> Array:
    var space_state := context.battle.get_world_2d().direct_space_state
    var params := PhysicsShapeQueryParameters2D.new()
    

    params.shape = shape
    params.collision_mask = collision_mask

    var mode : SelectionSpec.SelectionMode = spec.mode
    match  mode:
        SelectionSpec.SelectionMode.CURSOR:
             params = _follow_mouse(context, params)
        SelectionSpec.SelectionMode.AUTO_AROUND_CASTER:
             params = _center_on_caster(context , params)
    
    var result := space_state.intersect_shape(params, spec.max_targets)
    
    var nodes : Array[Node] = []
    for d in result:
        nodes.append(d["collider"])
    return nodes



    
func _follow_mouse(context: CardContext , params : PhysicsShapeQueryParameters2D) -> PhysicsShapeQueryParameters2D:
    var mouse_position = context.battle.get_global_mouse_position()
    params.transform = Transform2D(0 , mouse_position)
    return params



func _center_on_caster(context: CardContext , params: PhysicsShapeQueryParameters2D) -> PhysicsShapeQueryParameters2D:
    params.transform = Transform2D(0 , context.unit.global_position)
    return params