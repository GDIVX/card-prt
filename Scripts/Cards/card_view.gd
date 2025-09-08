class_name CardView
extends Control

@export_category("params")
@export var header: String
@export var description: String
@export var artwork: Texture2D
@export var cost: int

@export_category("nodes")
@export var _header_label: Label
@export var _description_label: RichTextLabel 
@export var _artwork_sprite: TextureRect
@export var _cost_label: Label

@export_category("hover")
@export var hover_scale: Vector2 = Vector2(1.1, 1.1)
@export var hover_y_offset: float = -10
@export var hover_tween_duration: float = 0.2
@export var reset_tween_duration: float = 0.3


@export_category("Text")
@export var playable_color:Color = Color.WHITE
@export var unplayable_color:Color = Color.RED
@export var text_color_transition_duration:float = 0.2

var _original_scale: Vector2
var _original_position: Vector2

func _ready() -> void:
	_original_scale = self.scale
	_original_position = self.position




func display_card():
	_header_label.text = header
	_description_label.text = description
	_artwork_sprite.texture = artwork
	_cost_label.text = str(cost)


func assign_data(data: CardStyle, cost_value: int):
	header = data.Header
	description = data.Description
	artwork = data.Artwork
	cost = cost_value


var tween: Tween

func  _refresh_tween() -> void:
	if tween:
		tween.kill()
	tween = get_tree().create_tween()

func _on_card_frame_mouse_entered() -> void:

	_refresh_tween()

	tween.parallel().tween_property(self, "position", self.position + Vector2(0, hover_y_offset), hover_tween_duration)\
	.set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)

	tween.parallel().tween_property(self, "scale", hover_scale, hover_tween_duration)\
	.set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)
	z_index = 1000  # Bring to front when hovered


func _on_card_frame_mouse_exited() -> void:

	_refresh_tween()
	var finished = func ():
		self.position = _original_position
		self.scale = _original_scale

	tween.parallel().tween_property(self, "position", _original_position, reset_tween_duration)\
	.set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)

	tween.parallel().tween_property(self, "scale", _original_scale, reset_tween_duration)\
	.set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT).finished.connect(finished)
	z_index = 0  # Reset z-index when not hovered

	#snap for safety

func show_playable_state(value: bool) -> void:

	var color: Color = playable_color if value else unplayable_color

	_refresh_tween()

	tween.parallel().tween_property(_header_label.label_settings, "font_color", color, text_color_transition_duration)\
	.set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)

	tween.parallel().tween_property(_cost_label.label_settings, "font_color", color, text_color_transition_duration)\
	.set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)
