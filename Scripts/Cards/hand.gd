class_name  Hand extends Control

@export var card_scene: PackedScene
@export var fan: FanContainer

var cards: Array[Card] = []

signal card_created(card: Card)

func create_card(data: CardData) -> Card:
	var instant = card_scene.instantiate()
	var card: Card = instant as Card

	card.ready.connect(func ():
		card.bind(data.duplicate(true))
		card_created.emit(card))

	
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


func activate_cards_when(delegate: Callable) -> void:
	if not delegate.is_valid():
		push_error("activate_cards_when: passed an invalid callable")
		return
	
	for card in cards:
		print(card)
		var result = null
		result = delegate.call(card)

		if typeof(result) != TYPE_BOOL:
			push_error("activate_cards_when: delegate must return a bool (got %s)" % typeof(result))
			continue  
		
		card.is_playable = result
