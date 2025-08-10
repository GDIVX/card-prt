class_name Counter extends Control

@export_category("Nodes")
@export var counter_label: Label

func set_count(text) -> void:
	if not counter_label: return

	if text is String:
		counter_label.text = text
		return
	counter_label.text = str(text)

