class_name ClickAndDragMovement extends Node

@export var movement_points : ObservableNumber
@export var drag : DragHandle



func _on_character_drag_before_started_dragging() -> void:
	drag.enabled = movement_points.value > 0
