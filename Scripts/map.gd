class_name Map
extends Node2D

@export var border_size: Vector2 = Vector2(1024, 768)   # Playable area (centered on this node)
@export var border_thickness: float = 64.0              # Wall thickness outward from edges
@export var border_bias: float = 0.0                    # Optional inward offset
@export var border_texture: Texture2D                   # Texture to tile along the walls
@export var uv_tiles: Vector2 = Vector2(1, 1)           # How many times to repeat per wall (X/Y)

var _walls: Node2D
var _visuals: Node2D

func _ready() -> void:
	if Engine.is_editor_hint():
		# Only draw editor preview; don't spawn physics in the editor.
		queue_redraw()
		return
	_rebuild()

func _rebuild() -> void:
	_clear_children()
	_walls = Node2D.new()
	_visuals = Node2D.new()
	_walls.name = "Walls"
	_visuals.name = "WallVisuals"
	add_child(_walls)
	add_child(_visuals)

	var half := border_size * 0.5

	# left / right walls (vertical strips)
	_make_wall(Vector2(-half.x - border_thickness * 0.5 + border_bias, 0.0),
			   Vector2(border_thickness, border_size.y + border_thickness * 2))
	_make_wall(Vector2( half.x + border_thickness * 0.5 - border_bias, 0.0),
			   Vector2(border_thickness, border_size.y + border_thickness * 2))

	# top / bottom walls (horizontal strips)
	_make_wall(Vector2(0.0, -half.y - border_thickness * 0.5 + border_bias),
			   Vector2(border_size.x + border_thickness * 2, border_thickness))
	_make_wall(Vector2(0.0,  half.y + border_thickness * 0.5 - border_bias),
			   Vector2(border_size.x + border_thickness * 2, border_thickness))


func _make_wall(center_pos: Vector2, size: Vector2) -> void:
	# --- Collision ---
	var body := StaticBody2D.new()
	var shape := CollisionShape2D.new()
	var rect := RectangleShape2D.new()
	rect.size = size
	shape.shape = rect
	body.position = center_pos
	body.add_child(shape)
	_walls.add_child(body)


	# --- Visual (Sprite2D with proper tiling) ---
	if border_texture:
		var s := Sprite2D.new()
		s.name = "WallSprite"
		s.texture = border_texture
		s.centered = true
		s.position = center_pos

		# Godot 4: repeat is on CanvasItem (not import settings)
		s.texture_repeat = CanvasItem.TEXTURE_REPEAT_ENABLED  # or TEXTURE_REPEAT_MIRROR
		s.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST

		# Enable region so we can make the sprite draw as big as the wall.
		s.region_enabled = true

		# Region size controls how many texture tiles we "sample".
		# Then we shrink by the inverse so the world size stays equal to 'size'.
		var tiles := Vector2(max(uv_tiles.x, 1.0), max(uv_tiles.y, 1.0))
		s.region_rect = Rect2(Vector2.ZERO, size * tiles)
		s.scale = Vector2(1.0 / tiles.x, 1.0 / tiles.y)

		_visuals.add_child(s)




func _clear_children() -> void:
	for c in get_children():
		if c is Node:
			c.queue_free()
