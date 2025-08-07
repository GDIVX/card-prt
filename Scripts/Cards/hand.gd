class_name  Hand extends Control

@export var card_scene: PackedScene
@export var fan: FanContainer

var cards: Array[Card] = []

func create_card(data: CardData) -> Card:
	var instant = card_scene.instantiate()
	var card: Card = instant as Card
	card.bind(data.duplicate(true))
	add_child(instant)
	cards.append(card)
	fan.arrange_cards(cards)
	return card

func _on_button_pressed() -> void:
	#TODO: Tempt
	var card_data = load("res://Resources/Cards/card_test.tres")
	create_card(card_data)
