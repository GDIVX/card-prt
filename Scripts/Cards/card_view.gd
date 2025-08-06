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

