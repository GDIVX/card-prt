class_name RaycastSelectionView
extends SelectionView

@export var line: Line2D
@export var raycast: RayCast2D

@export var main_gradient: Gradient
@export var second_gradient: Gradient

@export var sampling_curve: Curve


func set_spec(spec: SelectionSpec, context: CardContext) -> void:
	super.set_spec(spec, context)
	raycast.add_exception(context.unit)
	raycast.add_exception(context.unit.get_node("Hitbox"))

func _physics_process(_delta: float) -> void:
	var mouse := get_global_mouse_position()

	# Line endpoints
	line.points[0] = _context.unit.global_position
	raycast.target_position = mouse

	if raycast.is_colliding():
		line.points[1] = raycast.get_collision_point()
	else:
		line.points[1] = mouse

	# Distance → normalized sample (guard against zero range)
	var max_r : float= max(0.0001, _spec.max_range)
	var distance := _context.unit.global_position.distance_to(line.points[1])
	var t_linear := clampf(distance / max_r, 0.0, 1.0)

	# Curved remap for perceptual/control goodness
	var t := sampling_curve.sample_baked(t_linear)

	# Colors from gradients using curved t
	var color_main := main_gradient.sample(t)
	var color_second := second_gradient.sample(t)

	# Push into the shader
	var mat := line.material as ShaderMaterial
	if mat:
		mat.set_shader_parameter("color1", color_main)
		mat.set_shader_parameter("color2", color_second)
