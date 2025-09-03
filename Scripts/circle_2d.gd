@tool
class_name Circle2D
extends Polygon2D

@export_custom(PROPERTY_HINT_NONE, "suffix:px") var radius: float = 20.0 : set = _set_radius
@export_range(12, 10_000) var segments: int = 30 : set = _set_segments


func _ready() -> void:
    _rebuild()

func _set_radius(v: float) -> void:
    radius = max(0.0, v)
    _rebuild()

func _set_segments(v: int) -> void:
    segments = clampi(v, 3, 10_000)
    _rebuild()


func _rebuild() -> void:
    if radius <= 0.0 or segments < 3:
        polygon = PackedVector2Array()
        uv = PackedVector2Array()
        return

    var pts := PackedVector2Array()
    var uvs := PackedVector2Array()
    pts.resize(segments)
    uvs.resize(segments)

    for i in segments:
        var a := TAU * float(i) / float(segments)
        var v := Vector2(cos(a), sin(a)) * radius
        pts[i] = v
        # map (-radius..+radius) -> (0..1), center at (0.5, 0.5)
        uvs[i] = v / (radius * 2.0) + Vector2(0.5, 0.5)

    polygon = pts
    uv = uvs
    _update_shader_mat()


func _update_shader_mat() -> void:
    var mat := material as ShaderMaterial
    mat.set_shader_parameter("radius" , radius)
