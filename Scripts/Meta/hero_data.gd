## Hold data required for the creation and management of heroes in the game.
class_name HeroData extends Resource

@export var unit_scene : PackedScene

@export_category("General")
@export var name: String

@export_category("Card Collection")
@export var starting_cards: Array[CardData] 
@export var unlocked_cards: Array[CardData] = []