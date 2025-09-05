@icon("res://Sprites/IconGodotNode/color/icon_life_bar.png")
class_name HealthBar
extends TextureProgressBar

@export var health_object: Health

@onready var _health_label: Label = $Label
@onready var _defense_counter: Counter = $DefenseCounter

@export_category("Fill")
@export var fill_tween_duration: float = 0.3
@export var fill_tween_trans: Tween.TransitionType
@export var fill_tween_ease: Tween.EaseType
@export var fill_color_healthy: Color = Color.RED
@export var fill_color_unhealthy: Color = Color.BLACK


func _on_health_health_changed(current_value:int) -> void:
	# TODO: blink shader would be nice
	
	_show_health_widget(current_value)
	var max_health := health_object.max_health
	if current_value == max_health and health_object.defense == 0: 
		_hide_health_widget()



func _show_health_widget(current_value: int) -> void:
	var max_health := health_object.max_health
	var _ratio: float = current_value as float / max_health as float

	if not _health_label:
		_health_label = $Label
	_health_label.text = "%s/%s" % [current_value , max_health]
	var tween: Tween = get_tree().create_tween()

	tween.tween_property(self , "value" , _ratio , fill_tween_duration)\
	.set_trans(fill_tween_trans).set_ease(fill_tween_ease)

	var fill_color = lerp(fill_color_unhealthy , fill_color_healthy , _ratio)
	tween.parallel().tween_property(self, "tint_progress" , fill_color , fill_tween_duration)\
	.set_trans(fill_tween_trans).set_ease(fill_tween_ease)


	tween.parallel().tween_property(_health_label , "self_modulate" , Color.WHITE, fill_tween_duration)

func _hide_health_widget() -> void:
	var tween: Tween = get_tree().create_tween()
	tween.tween_property(_health_label , "self_modulate" , Color.TRANSPARENT, fill_tween_duration)
	tween.parallel().tween_property(self , "self_modulate" , Color.TRANSPARENT, fill_tween_duration)


func _on_health_defense_changed(current_value:int) -> void:
	# TODO: blink shader would be nice

	if not _defense_counter:
		_defense_counter = $DefenseCounter
	_defense_counter.set_count(current_value)

	# if defense is 0, we don't need to show it
	var color := Color.TRANSPARENT if current_value == 0 else Color.WHITE
	var tween: Tween = get_tree().create_tween()
	tween.tween_property(_defense_counter , "self_modulate", color , fill_tween_duration)
	# if defense is above 0, show health too
	if current_value == 0 : return
	_show_health_widget(health_object.current_health)
