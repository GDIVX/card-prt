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


func remove_card(card: Card) -> void:
	if card in cards:
		cards.erase(card)
		card.queue_free()
		fan.arrange_cards(cards)
	else:
		push_error("Card not found in hand.")