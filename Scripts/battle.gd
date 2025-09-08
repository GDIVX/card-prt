# manager class for the battle system
class_name Battle extends Node2D

@export_category("Nodes")
@export var card_gameplay_system: CardGameplaySystem
@export var game_resources_system: GameResourcesSystem
@export var selection : SelectionController
@export var map : NavigationRegion2D

@export var heroes_data:Array[HeroData]

@export_category("Spawn Location")
@export var spawn_position_center : Vector2
@export var spawn_radius: float

var player_units: Dictionary[String, PlayerUnit]

var _selection_active: bool = false
var _pending_card: Card = null


func _ready() -> void:
	if not card_gameplay_system:
		push_error("CardGameplaySystem is not set. Please set it in the inspector.")
		return


	selection.selection_completed.connect(_on_selection_completed )
	selection.selection_canceled.connect(_on_selection_canceled )


	# Initialize the hero deck
	if heroes_data and heroes_data.size() > 0:
		for hero in heroes_data:
			create_hero(hero, _get_spawn_position())
	card_gameplay_system.draw_hand()


func _get_spawn_position() -> Vector2:
	var angle = randf() * TAU
	var radius = sqrt(randf()) * spawn_radius
	var x = radius * cos(angle)
	var y = radius * sin(angle)
	return Vector2(x, y)


func create_hero(hero_data: HeroData, spawn_point : Vector2) -> PlayerUnit:
	_create_hero_deck(hero_data)
	var unit: PlayerUnit = hero_data.unit_scene.instantiate() as PlayerUnit
	if not unit:
		push_error("Hero " + hero_data.name + " lack a [PlayerUnit] scene")
		return null
	
	unit.position = spawn_point
	player_units[hero_data.name] = unit
	add_child(unit)
	return unit
	


func _create_hero_deck(hero_data: HeroData) -> void:
	card_gameplay_system.register_deck_key(hero_data.name )
	card_gameplay_system.setup_draw_pile(hero_data.name, hero_data.starting_cards)


func _on_game_resources_system_resource_value_changed(key:String, _value:int) -> void:
	if key=="mana":
		_toggle_cards_playable_when_affordable()


func can_afford_card(card:Card) -> bool:
	var mana = game_resources_system.get_resource("mana")
	return card.data.cost <= mana


func _toggle_cards_playable_when_affordable() -> void:
	if card_gameplay_system.hand:
		card_gameplay_system.hand.set_cards_playable_when(can_afford_card)

func _on_hand_card_created(card:Card) -> void:
	card.is_playable = can_afford_card(card)



func _on_card_gameplay_system_card_created_with_key(key:String, card:Card) -> void:
	var unit := player_units[key]
	var context: CardContext = CardContext.new()
	context.battle = self
	context.unit = unit
	context.selection_spec = card.data.selection.duplicate(true)
	card.context = context

	card.pending_play.connect(_on_card_pending_play)

	
func _on_card_pending_play(card: Card) -> void:
	if _selection_active:
		return
	_selection_active = true
	_pending_card = card

	if card_gameplay_system.hand:
		card_gameplay_system.hand.set_cards_playable_when(func (other_card: Card):
			return other_card == card)
	_handle_selection()


func _handle_selection() -> void:

	if not _selection_active:
		push_error("Tried to handle selection while selection is not active")
		return
	if not _pending_card:
		push_error("Null reference : pending card was not assigned when trying to handle selection")
		return

	var spec: SelectionSpec = _pending_card.data.selection
	if spec == null:
		push_error("Missing selection specs for the card" + _pending_card.data.to_string())


	selection.start_selection(_pending_card.context, spec)
	


func _on_selection_completed(results : Array) -> void:
	_pending_card.card_player.play(_pending_card,results)
	var cost = _pending_card.data.cost
	game_resources_system.add_resource("mana",-cost)
	_selection_cleanup()
	


func _on_selection_canceled() -> void:
	_selection_cleanup()
	

func  _selection_cleanup() -> void:
	_selection_active = false
	_toggle_cards_playable_when_affordable()
	_pending_card = null
	selection.all_targets.clear()

func _on_card_gameplay_system_card_discarded(card:Card) -> void:
	card.pending_play.disconnect(_on_card_pending_play)
