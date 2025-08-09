## A resource that holds the data for a card
## It is used to create a card instance in the game
class_name CardData
extends Resource

## The card style defines the visual representation of the card
@export var card_style : CardStyle

@export_category("Stats")
## The Rarity of the card, used to determine its availability and power level
@export_enum("Common", "Uncommon", "Rare", "Epic", "Legendary") var rarity: String = "Common"
## The cost of the card, used to determine if the player can play it
@export var cost: int



@export_category("Targeting")
## The range from the caster that the card can be played
## Range 0 would be interpreted as "self" - the card only effect the caster, or that world position dose not matter
@export_range(0,20) var targeting_range: float = 0


@export_category("Effects")
## The effects that the card has when played
## Each effect is a CardEffect resource that defines the effect's behavior 
@export var card_effects: Array[CardEffect]

func _get_configuration_warning() -> String:
	var warnings = []
	if card_style == null:
		warnings.append("Card Style is not set! The card will have no visuals.")
	if card_effects.is_empty():
		warnings.append("Card has no effects! It will do nothing when played.")
	return "\n".join(warnings)
