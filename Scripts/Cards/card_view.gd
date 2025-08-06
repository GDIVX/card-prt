class_name CardView
extends Node2D

@export var header: String
@export var description: String
@export var artwork: Texture2D
@export var cost: int

#nodes to display params
var _header_label: Label
var _description_label: RichTextLabel 
var _artwork_sprite: Sprite2D
var _cost_label: Label


func _ready() -> void:
	_header_label = get_node("CardFrame/Header") 
	_description_label = get_node("CardFrame/Description")
	_artwork_sprite = get_node("Artwork Container/Artwork")
	_cost_label = get_node("CostFrame/CostLabel")


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

