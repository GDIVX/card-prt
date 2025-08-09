## A deck of cards that handles collection and movement of cards.
## Cards are handled by this script as pure data.
## We recommend using [CardData] for card data, but this script is agnostic to the data type.
## To display playable cards, use the hand script.
## [br]
## A collection is an array of CardData objects.
## It can represent a draw pile, discard pile, or any other collection of cards.
## This script [b]won't[/b] handle the movement of lifecycle of cards,
## only their collection and organization.
## You will need to use the deposit and withdraw methods to manage the cards.
class_name Deck extends Node

## A dictionary of collections, where the key is the collection name and the value is an array.
@export var collections: Dictionary[String, Array] = {}


## Called when a card is being deposited to a collection
signal card_deposited(collection_name: String, card)
## Called when a card is being withdrawn from a collection
signal card_withdrawn(collection_name: String, card)


## Add a new collection to the deck.
## If the collection already exists, it will be overwritten.
## @param force If true, it will overwrite the existing collection.
func add_collection(collection_name: String, force: bool = false) -> Array:
    if collection_name in collections and not force:
        push_warning("Collection '%s' already exists. Skipping." % collection_name)
        return collections[collection_name]
    collections[collection_name] = []
    return collections[collection_name]


## Deposit a card into the start a collection.
## If the collection does not exist, it will be created.
func deposit(collection_name: String, obj) -> void:
    if not collection_name in collections:
        add_collection(collection_name)
    collections[collection_name].push_front(obj)
    emit_signal("card_deposited", collection_name, obj)


## Withdraw a card from the start of a collection.
## If the collection does not exist or is empty, it will return null.
func withdraw(collection_name: String) -> Variant:
    if not collection_name in collections:
        push_error("Collection '%s' does not exist." % collection_name)
        return null
    if collections[collection_name].size() == 0:
        push_error("Collection '%s' is empty." % collection_name)
        return null
    var obj = collections[collection_name].pop_front()
    emit_signal("card_withdrawn", collection_name, obj)
    return obj


## Get the size of a collection.
## If the collection does not exist, it will return 0.
func get_collection_size(collection_name: String) -> int:
    if not collection_name in collections:
        push_error("Collection '%s' does not exist." % collection_name)
        return 0
    return collections[collection_name].size()


## Get a collection by name.
## If the collection does not exist, it will return null.
func get_collection(collection_name: String) -> Array:
    if not collection_name in collections:
        push_error("Collection '%s' does not exist." % collection_name)
        return []
    return collections[collection_name]


## Clear a collection.
## If the collection does not exist, it will do nothing.
func clear_collection(collection_name: String) -> void:
    if not collection_name in collections:
        push_error("Collection '%s' does not exist." % collection_name)
        return
    collections[collection_name].clear()


## Shuffle a collection.
## If the collection does not exist, it will do nothing.
func shuffle_collection(collection_name: String) -> void:
    if not collection_name in collections:
        push_error("Collection '%s' does not exist." % collection_name)
        return
    var collection = collections[collection_name]
    if collection.size() == 0:
        push_warning("Collection '%s' is empty, nothing to shuffle." % collection_name)
        return
    collection.shuffle()

## Move an element from one collection to another.
## If the source collection does not exist or is empty, it will do nothing.
func move_element(source_collection: String, target_collection: String) -> void:
    if not source_collection in collections:
        push_error("Source collection '%s' does not exist." % source_collection)
        return
    if not target_collection in collections:
        add_collection(target_collection)
    if collections[source_collection].size() == 0:
        push_warning("Source collection '%s' is empty, nothing to move." % source_collection)
        return
    var element = collections[source_collection].pop_front()
    collections[target_collection].push_front(element)  

## Peek at the top card of a collection without removing it.
func peek(collection_name: String) -> Variant:
    if not collections.has(collection_name) or collections[collection_name].is_empty():
        return null
    return collections[collection_name][0]
