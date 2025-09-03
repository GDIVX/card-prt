class_name RaycastSelectionView
extends SelectionView

@export var line: Line2D

@export var main_gradient: Gradient
@export var second_gradient: Gradient

@export var sampling_curve: Curve

var raycast: RayCast2D

func set_spec(spec: SelectionSpec, context: CardContext) -> void:
	super.set_spec(spec, context)
	raycast = context.unit.raycast
	raycast.enabled = true


func _physics_process(_delta: float) -> void:

	# Line endpoints

	# Define the ray segment from caster toward mouse, clamped by max_range
	var from := _context.unit.global_position
	var mouse := _context.battle.get_global_mouse_position()
	var dir := mouse - from
	if dir.length() > _spec.max_range:
		dir = dir.normalized() * _spec.max_range
	var to := from + dir

	raycast.global_position = from
	raycast.target_position = raycast.to_local(to)

	line.points[0] = from
	if raycast.is_colliding():
		line.points[1] = raycast.get_collision_point()
		#skip distance coloring and color by team
		var node := raycast.get_collider() as Node
		var is_valid := _matches_team_mask(node)
		var sample : float = 0 if is_valid else 1

		var color_main := main_gradient.sample(sample)
		var color_second := second_gradient.sample(sample)
		set_shader_colors(color_main , color_second)
	else:
		line.points[1] = to

		# Distance → normalized sample (guard against zero range)
		var max_r : float= max(0.0001, _spec.max_range)
		var distance := _context.unit.global_position.distance_to(line.points[1])
		var t_linear := clampf(distance / max_r, 0.0, 1.0)

		# Curved remap for perceptual/control goodness
		var t := sampling_curve.sample_baked(t_linear)

		# Colors from gradients using curved t
		var color_main := main_gradient.sample(t)
		var color_second := second_gradient.sample(t)
		set_shader_colors(color_main , color_second)


func set_shader_colors(main : Color , second : Color) -> void:
	# Push into the shader
	var mat := line.material as ShaderMaterial
	if mat:
		mat.set_shader_parameter("color1", main)
		mat.set_shader_parameter("color2", second)


## Check if [param target] matches the team mask relative to [param caster].
##[br]
## If [code]caster == target[/code], requires [SelectionSpec.TeamMask.CASTER].[br]
## If either side lacks [Team], treated as neutral and requires [enum SelectionSpec.TeamMask] to be [b]NEUTRAL[/b].[br]
## Otherwise compares [method Team.get_relative_relation] against [b]ALLY[/b], [b]ENEMY[/b], [b]NEUTRAL[/b].[br]
## Returns: [bool].
func _matches_team_mask( target: Node) -> bool:
	var mask := _spec.relation_mask
	if mask == Team.RelativeRelation.ANY: return true
	var caster_team := _get_team(_context.unit)
	var target_team := _get_team(target)

	if not caster_team: return false
	if not target_team: return false

	var relation := caster_team.get_relative_relation(target_team.faction)
	return relation == mask
	


## Resolve a [annotation Team] component from a node.
##[br]
## Looks for a child [Node] named [u]Team[/u], then scans direct children for a [Team] instance.[br]
## Returns: [Team] or [code]null[/code].
func _get_team(node: Node) -> Team:
	var t := node.get_node_or_null("Team")
	if t is Team:
		return t
	for child in node.get_children():
		if child is Team:
			return child
	for sibling in node.get_parent().get_children():
		if sibling is Team:
			return sibling
	return null
