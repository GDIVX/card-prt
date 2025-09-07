class_name  Hand extends Control

@export var card_scene: PackedScene
@export var fan: FanContainer

@export var card_spawn_position: Vector2
@export var card_despawn_position: Vector2

var cards: Array[Card] = []

signal card_created(card: Card)

func create_card(data: CardData) -> Card:
	var instant = card_scene.instantiate()
	var card: Card = instant as Card
	card.position = card_spawn_position

	card.ready.connect(func ():
		card.bind(data.duplicate(true))
		card_created.emit(card))

	
	add_child(instant)
	cards.append(card)
	fan.arrange_cards(cards)
	return card


func remove_card(card: Card) -> void:
	if card in cards:
		# Play the despawn animation, then free the card when it ends
		var duration := 1.0
		card.card_transform_animator._is_despawning = true
		card.card_transform_animator.animate_to(card_despawn_position, card.rotation_degrees, duration)
		await get_tree().create_timer(duration).timeout
		cards.erase(card)
		card.queue_free()
		fan.arrange_cards(cards)
	else:
		push_error("Card not found in hand.")


func set_cards_playable_when(delegate: Callable) -> void:
	if not delegate.is_valid():
		push_error("set_cards_playable_when: passed an invalid callable")
		return
	
	for card in cards:
		var result = null
		result = delegate.call(card)

		if typeof(result) != TYPE_BOOL:
			push_error("set_cards_playable_when: delegate must return a bool (got %s)" % typeof(result))
			continue  
		
		card.is_playable = result

	
