class_name Card
extends Node2D

@export_category("Transform Animator")
@export var on_hover_scale: Vector2 = Vector2(1.1, 1.1)
@export var on_hover_y_offset: float = -10
@export var on_hover_tween_duration: float = 0.2
@export var on_reset_tween_duration: float = 0.3

var _is_bind = false
@onready var card_view: CardView = $CardView
@onready var card_player: CardPlayer = $CardPlayer
@onready var card_transform_animator: CardTransformAnimator = $CardTransformAnimator


## Bind card data to the card
func bind(data: CardData):
	card_view.assign_data(data.card_style, data.cost)
	card_player.bind_data(data.card_effects, data.targeting_range, data.cost)
	
	_is_bind = true

## Activate a card. If it isn't binned, the operation would fail
func activate():
	if not _is_bind:
		push_error("Can't activate a card before it is binned")
		return
	card_view.display_card()


func _handle_card_play() -> void:
	if not _is_bind:
		push_error("Can't play a card before it is binned")
		return
	#TODO: implement target finding
	card_player.play()





func _on_drag_stopped_dragging() -> void:
	pass # Replace with function body.


func _on_drag_started_dragging() -> void:
	pass # Replace with function body.


func _on_area_2d_mouse_exited() -> void:
	var drag:Drag = $Drag
	if drag and drag.is_selected: return
	# reset the card transform to the anchor
	card_transform_animator.reset(on_reset_tween_duration)

func _on_area_2d_mouse_entered() -> void:
	var drag:Drag = $Drag
	if drag and drag.is_selected: return
	# Scale the card and slightly move it up when hovered
	card_transform_animator.animate_to_scale(on_hover_scale, on_hover_tween_duration)
	card_transform_animator.animate_to(
		card_transform_animator.anchor_position + Vector2(0, on_hover_y_offset),
		card_transform_animator.anchor_rotation_degrees,
		on_hover_tween_duration
	)
	
