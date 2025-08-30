@tool
class_name Circle2D extends Polygon2D


@export_custom(PROPERTY_HINT_NONE, "suffix:px") var radius: float = 20
@export_range(12,10_000) var segments : int = 30

func calculate_circle() -> void:
    var points: Array[Vector2] = []
    for i in range(segments):
        var angle = (TAU * i) / segments
        var x = cos(angle)
        var y = sin(angle)
        points.append(Vector2(x,y) * radius)
    polygon = points


func _ready() -> void:
    calculate_circle()
        

    