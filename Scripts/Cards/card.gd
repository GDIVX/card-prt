class_name Card
extends Node2D

var _is_bind = false
@onready var card_view: CardView = $CardView
@onready var card_player: CardPlayer = $CardPlayer
@onready var card_movement: CardMovement = $CardMovement


## Bind card data to the card
func bind(data: CardData):
	card_view.assign_data(data.card_style, data.cost)
	card_player.bind_data(data.card_effects, data.targeting_range, data.cost)
	
	_is_bind = true

## Activate a card. If it isn't binned, the operation would fail
func activate():
	if not _is_bind:
		push_error("Can't activate a card before it is binned")
		return
	card_view.display_card()



func _handle_card_play() -> void:
	if not _is_bind:
		push_error("Can't play a card before it is binned")
		return
	#TODO: implement target finding
	card_player.play()


