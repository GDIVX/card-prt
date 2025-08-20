class_name CardPlayer
extends Node

var _card_effects: Array[CardEffect]

## Flag if the card has been resolved.
## If you set this to TRUE while in [play], the function would return early, and won't emit the signal
## Useful for when you need to interrupt the effects sequence or prevent the card from discarding.
var is_resolved: bool = false

        
## Called when a card has completed all of its effects without resolving early
signal card_late_resolved(card: Card)

func bind_data(effects : Array[CardEffect]) -> void:
    _card_effects = effects


func play(card: Card,targets : Array) -> void:
    is_resolved = false # ensure at least the first effect would be played
    for effect: CardEffect in _card_effects:
        if is_resolved: return # return early if resolved early
        effect.apply(card, targets)
    is_resolved = true
    card_late_resolved.emit(card)


