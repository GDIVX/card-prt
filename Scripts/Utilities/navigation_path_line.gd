class_name NavigationPathLine
extends Line2D

@export var short_length: float = 250.0
@export var tail_uses_own_material_instance: bool = false
@export var tail_material_override: ShaderMaterial

var _enabled := false
var _tail: Line2D

func _ready() -> void:
	_tail = Line2D.new()

	# Mirror visuals so both segments feel like one line.
	_tail.width = width
	_tail.begin_cap_mode = begin_cap_mode
	_tail.end_cap_mode = end_cap_mode
	_tail.joint_mode = joint_mode
	_tail.sharp_limit = sharp_limit
	_tail.texture = texture
	_tail.texture_mode = texture_mode
	_tail.texture_repeat = texture_repeat
	_tail.antialiased = antialiased

	# Use a shader on the second segment too.
	# Priority: explicit override > duplicated instance > shared material.
	if tail_material_override:
		_tail.material = tail_material_override
	else:
		var base_mat := material
		if base_mat and tail_uses_own_material_instance:
			_tail.material = base_mat.duplicate(true)
		else:
			_tail.material = base_mat

	add_child(_tail)
	_tail.visible = false

func _process(_delta: float) -> void:
	if not _enabled:
		return

	var mouse_position := get_global_mouse_position()
	var map: RID = get_world_2d().navigation_map
	var world_path := NavigationServer2D.map_get_path(map, global_position, mouse_position, true)

	for i in world_path.size():
		world_path[i] = to_local(world_path[i])

	var parts := _split_path_at_length(world_path, short_length)
	var short_points: PackedVector2Array = parts[0]
	var long_points: PackedVector2Array  = parts[1]

	# Draw first (short) segment — shader/color comes from this node's material.
	points = short_points
	visible = _enabled and points.size() >= 2

	# Draw second (long) segment with its own Line2D that also uses a shader.
	_tail.points = long_points
	_tail.visible = _enabled and _tail.points.size() >= 2

func enable_path() -> void:
	_enabled = true
	visible = true
	if _tail:
		_tail.visible = true

func disable() -> void:
	_enabled = false
	points.clear()
	visible = false
	if _tail:
		_tail.points.clear()
		_tail.visible = false

func _on_character_drag_started_dragging(_start_position: Vector2) -> void:
	enable_path()

func _on_character_drag_stopped_dragging(_end_position: Vector2) -> void:
	disable()

# --- Helpers ---
func _split_path_at_length(path: PackedVector2Array, cutoff: float) -> Array[PackedVector2Array]:
	var short_points := PackedVector2Array()
	var long_points  := PackedVector2Array()

	if path.size() == 0:
		return [short_points, long_points]

	short_points.append(path[0])
	if path.size() == 1:
		return [short_points, long_points]

	var acc := 0.0
	for i in range(1, path.size()):
		var a := path[i - 1]
		var b := path[i]
		var seg_len := a.distance_to(b)

		if acc + seg_len <= cutoff:
			short_points.append(b)
			acc += seg_len
		else:
			var remain := cutoff - acc
			var t: float = 0.0
			if seg_len > 0.0:
				t = clamp(remain / seg_len, 0.0, 1.0)

			var cut_pt := a.lerp(b, t)

			if short_points[short_points.size() - 1] != cut_pt:
				short_points.append(cut_pt)

			long_points.append(cut_pt)
			if t < 1.0:
				long_points.append(b)
			for j in range(i + 1, path.size()):
				long_points.append(path[j])
			break

	return [short_points, long_points]
