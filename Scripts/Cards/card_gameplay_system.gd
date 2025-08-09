## A system that manages the gameplay of cards, including drawing, playing, and discarding cards.
class_name CardGameplaySystem
extends CanvasLayer

@export var deck: Deck
@export var hand: Hand

## Dictionary of per-key hand draw amounts, e.g., { "hero_1": 2, "enemy": 3 }
var hand_draw_amounts: Dictionary = {}

const META_DECK_KEY := "deck_key"

signal draw_pile_empty(key: String)
signal discard_pile_empty(key: String)


func _ready() -> void:
    if not deck or not hand:
        push_error("Deck and/or Hand not set. Please set both in the inspector.")
        set_process(false)
        return

    # Ensure exile pile always exists
    deck.add_collection("exile")


## Registers draw/discard piles for a given key, and sets default hand size.
func register_deck_key(key: String, default_draw_count: int = 2) -> void:
    if not deck:
        push_error("Deck is not set.")
        return

    if hand_draw_amounts.has(key):
        push_warning("Key '%s' is already registered. Overwriting." % key)

    deck.add_collection(key + "_draw")
    deck.add_collection(key + "_discard")
    hand_draw_amounts[key] = default_draw_count


## Set the number of cards to draw for a given key when calling draw_hand().
func set_hand_size_for_key(key: String, count: int) -> void:
    if not _ensure_key_registered(key):
        return
    hand_draw_amounts[key] = count


## Initializes the draw pile for a key with a list of CardData objects and shuffles.
func setup_draw_pile(key: String, cards: Array[CardData]) -> void:
    if not _ensure_key_registered(key):
        return

    for card_data in cards:
        deck.deposit(key + "_draw", card_data)

    deck.get_collection(key + "_draw").shuffle()


## Draws a card from a specific draw pile and returns the visual card instance.
func draw_card(key: String) -> Card:
    if not _ensure_key_registered(key):
        return null

    var card_data = _withdraw_from_draw(key)

    if not card_data:
        emit_signal("draw_pile_empty", key)
        return null

    var card = hand.create_card(card_data)
    card.set_meta(META_DECK_KEY, key)
    return card


## Reform a draw pile from its associated discard pile, and shuffle it.
func reform_draw_pile(key: String) -> void:
    if not _ensure_key_registered(key):
        return

    var discard_pile = deck.get_collection(key + "_discard")
    if discard_pile.is_empty():
        emit_signal("discard_pile_empty", key)
        push_error("Discard pile for key '%s' is empty. Cannot reform." % key)
        return

    for card_data in discard_pile:
        deck.deposit(key + "_draw", card_data)

    deck.clear_collection(key + "_discard")
    deck.get_collection(key + "_draw").shuffle()


## Discards a single card from hand into the appropriate discard pile.
func discard_card(card: Card) -> void:
    if not deck or not card:
        push_error("Cannot discard. Deck or card is null.")
        return

    if not card.has_meta(META_DECK_KEY):
        push_error("Card has no '%s' metadata. Cannot determine discard pile." % META_DECK_KEY)
        return

    var key = card.get_meta(META_DECK_KEY)
    if not _ensure_key_registered(key):
        return

    deck.deposit(key + "_discard", card.data)
    hand.remove_card(card)


## Discards all cards in hand belonging to the specified key.
func discard_hand(key: String) -> void:
    if not _ensure_key_registered(key) or not hand:
        return

    var cards_to_discard := []
    for card in hand.cards:
        if card.has_meta(META_DECK_KEY) and card.get_meta(META_DECK_KEY) == key:
            cards_to_discard.append(card)

    for card in cards_to_discard:
        discard_card(card)


## Draws cards up to the hand size for each registered key.
func draw_hand() -> void:
    for key in hand_draw_amounts.keys():
        var current_count = 0
        for card in hand.cards:
            if card.get_meta(META_DECK_KEY) == key:
                current_count += 1

        var needed = max(hand_draw_amounts[key] - current_count, 0)
        for i in range(needed):
            draw_card(key)


## --- Internal helpers ---

func _ensure_key_registered(key: String) -> bool:
    if not hand_draw_amounts.has(key):
        push_error("Key '%s' is not registered." % key)
        return false
    return true


func _withdraw_from_draw(key: String) -> CardData:
    var card_data = deck.withdraw(key + "_draw")

    if not card_data:
        if deck.get_collection_size(key + "_discard") > 0:
            reform_draw_pile(key)
            card_data = deck.withdraw(key + "_draw")
        else:
            push_error("Draw and discard piles are empty for key '%s'." % key)
    return card_data
