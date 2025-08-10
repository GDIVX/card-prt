class_name  CardTransformAnimator extends Node2D

## The resting position of the card. 
## Proper use:
	## When moving the card as a whole, animate_to the anchor and then call "move_to_anchor". For example, the position of the card in the hand.
	## When moving the card temporarily, such as a part of an animation, animate_to the card via its root node, and animate_to to anchor once you are done.
@export var anchor_position: Vector2
@export var anchor_rotation_degrees: float
@export var anchor_scale: Vector2 = Vector2(1, 1)

## The parent of the card to animate_to
var root: Node2D:
	get:
		if not root:
			root = get_parent()
			if not root or not root is Node2D:
				push_error("Parent must be Node2D")
				# Fallback to the current node if no parent is set
				root = self
		return root

var tween: Tween

func _ready() -> void:

	anchor_position = root.position
	anchor_rotation_degrees = root.rotation_degrees
	anchor_scale = root.scale


func move_to_anchor(duration: float = 1) -> void:
	animate_to(anchor_position,anchor_rotation_degrees,duration)


func snap_to_anchor() -> void:

	root.position = anchor_position
	root.rotation_degrees = anchor_rotation_degrees

## Move the root object without moving the anchor. 
## Remember to call move_to_anchor() to recall the card to its resting state
func animate_to(target_position: Vector2, target_rotation_degrees: float, duration: float = 1):
	if root == null:
		push_error("Root node is missing")

	reset_tween()
	
	tween.parallel().tween_property(root, "position", target_position, duration)\
		.set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_IN_OUT)

	tween.parallel().tween_property(root, "rotation_degrees", target_rotation_degrees, duration)\
		.set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_IN_OUT)


func reset_tween():
	if tween:
		tween.kill()
	tween = get_tree().create_tween()

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	# Move the card back to its anchor position when it exits the screen
	move_to_anchor(0.5)
