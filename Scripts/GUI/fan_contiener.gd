class_name FanContainer extends Control

@export var animation_speed: float = 1
@export_category("Spread")
@export var spread_curve: Curve
@export var hand_width: float = 2.0

@export_category("Hight")
@export var height_curve: Curve
@export var hand_height: float
@export_category("Rotation")
@export var rotation_curve: Curve
@export var rotation_strength: float = 0.3



func arrange_cards(cards: Array[Card]) -> void:
	var count = cards.size()
	for i in range(count):
		var normalized_index = 0.5
		if count > 1:
			normalized_index = float(i + 1) / float(count + 1)
		var card = cards[i].card_transform_animator

		var pos: Vector2
		pos.x = spread_curve.sample(normalized_index) * hand_width
		pos.y = height_curve.sample(normalized_index) * -hand_height
		card.anchor_position = pos

		card.anchor_rotation_degrees = rotation_curve.sample(normalized_index) * rotation_strength

		card.reset(animation_speed)
