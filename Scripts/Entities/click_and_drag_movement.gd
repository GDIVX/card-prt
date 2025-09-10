class_name ClickAndDragMovement extends Node

@export var movement_points : ObservableNumber
@export var drag : DragHandle
@export var path_line : NavigationPathLine
@export var unit : TacticalUnit


		

func _on_character_drag_before_started_dragging() -> void:
	drag.enabled = movement_points.value > 0
	path_line.short_length = unit.remaining_movement_length
