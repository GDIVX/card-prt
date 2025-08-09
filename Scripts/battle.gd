# manager class for the battle system
class_name Battle extends Node2D

@export var card_gameplay_system: CardGameplaySystem

@export var test_hero: HeroData

func _ready() -> void:
    if not card_gameplay_system:
        push_error("CardGameplaySystem is not set. Please set it in the inspector.")
        return

    # Initialize the hero deck
    if test_hero:
        create_hero(test_hero)
    # draw a hand for the hero
    card_gameplay_system.draw_hand()



func create_hero(hero_data: HeroData):
    _create_hero_deck(hero_data)


func _create_hero_deck(hero_data: HeroData) -> void:
    card_gameplay_system.register_deck_key(hero_data.name)
    card_gameplay_system.setup_draw_pile(hero_data.name, hero_data.starting_cards)