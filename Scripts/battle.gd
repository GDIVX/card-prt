# manager class for the battle system
class_name Battle extends Node2D

@export_category("Nodes")
@export var card_gameplay_system: CardGameplaySystem
@export var game_resources_system: GameResourcesSystem

@export var heroes:Array[HeroData]

func _ready() -> void:
	if not card_gameplay_system:
		push_error("CardGameplaySystem is not set. Please set it in the inspector.")
		return

	# Initialize the hero deck
	if heroes and heroes.size() > 0:
		for hero in heroes:
			create_hero(hero)
	card_gameplay_system.draw_hand()



func create_hero(hero_data: HeroData):
	_create_hero_deck(hero_data)


func _create_hero_deck(hero_data: HeroData) -> void:
	card_gameplay_system.register_deck_key(hero_data.name )
	card_gameplay_system.setup_draw_pile(hero_data.name, hero_data.starting_cards)


func _on_game_resources_system_resource_value_changed(key:String, value:int) -> void:
	if key=="mana":
		var can_afford_delegate: Callable = func (card: Card): return card.data.cost <= value
		if card_gameplay_system.hand:
			card_gameplay_system.hand.activate_cards_when(can_afford_delegate)


func can_afford_card(card:Card) -> bool:
	var mana = game_resources_system.get_resource("mana")
	return card.data.cost <= mana


func _on_hand_card_created(card:Card) -> void:
	card.is_playable = can_afford_card(card)
	print(card)
	print(card.is_playable)
