class_name CardData
extends Resource

@export var card_style : CardStyle

@export_category("Stats")
@export var cost: int


@export_category("Targeting")
## The range from the caster that the card can be played
## Range 0 would be interpreted as "self" - the card only effect the caster, or that world position dose not matter
@export_range(0,20) var targeting_range: float = 0


@export_category("Effects")
@export var card_effects: Array[CardEffectData]

