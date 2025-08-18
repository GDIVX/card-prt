## Represent a card in the game
##
## This script act as a mediator between the card view and the card player and any other card related logic
class_name Card
extends Node2D

@export_category("Nodes")
## The card view is responsible for displaying the card's information and animations in local space
@export var card_view: CardView
## The card player is responsible for handling the card's effects and interactions in the game
@export var card_player: CardPlayer
## The card transform animator is responsible for animating the card's position and rotation in world space
@export var card_transform_animator: CardTransformAnimator

var context: CardContext

## Indicates whether the card has been bound with data and is ready for activation
var _is_bind: bool = false
## Indicates if the card can be played
var is_playable:bool = false:
	set(value):
		is_playable = value
		card_view.show_playable_state(value)
		is_playable_changed.emit(self,value)

## The data resource of the card
var data: CardData

#signals
## Called when the card playable status had changed
signal is_playable_changed(card:Card, is_playable_value:bool)

## Bind card data to the card
func bind(card_data: CardData , should_activate: bool = true) -> void:
	data = card_data
	card_view.assign_data(card_data.card_style, card_data.cost)
	card_player.bind_data(card_data.card_effects, card_data.targeting_range, card_data.cost)
	
	_is_bind = true

	if should_activate:
		activate()
	else:
		self.visible = false

## Activate a card. If it isn't binned, the operation would fail
func activate():
	if not _is_bind:
		push_error("Can't activate a card before it is binned")
		return
	self.visible = true
	card_transform_animator.snap_to_anchor()
	card_view.display_card()
	is_playable = true


## Handle the card play action
func _handle_card_play() -> void:
	if not _is_bind:
		push_error("Can't play a card before it is binned")
		return
	if not is_playable: 
		#TODO: Implement reason
		return
	#TODO: implement target finding
	card_player.play()


## Handle the card view GUI input events
func _on_card_view_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			_handle_card_play()
