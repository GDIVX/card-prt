## A resource that holds the data for a card
## It is used to create a card instance in the game
class_name CardData
extends Resource

## The card style defines the visual representation of the card
@export var card_style : CardStyle

@export_category("Stats")
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

