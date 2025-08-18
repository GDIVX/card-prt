# manager class for the battle system
class_name Battle extends Node2D

@export_category("Nodes")
@export var card_gameplay_system: CardGameplaySystem
@export var game_resources_system: GameResourcesSystem

@export var heroes_data:Array[HeroData]

@export_category("Spawn Location")
@export var spawn_position_center : Vector2
@export var spawn_radius: float

var player_units: Dictionary[String, PlayerUnit]


func _ready() -> void:
	if not card_gameplay_system:
		push_error("CardGameplaySystem is not set. Please set it in the inspector.")
		return

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


func _on_game_resources_system_resource_value_changed(key:String, value:int) -> void:
	if key=="mana":
		var can_afford_delegate: Callable = func (card: Card): return card.data.cost <= value
		if card_gameplay_system.hand:
			card_gameplay_system.hand.activate_cards_when(can_afford_delegate)


func can_afford_card(card:Card) -> bool:
	var mana = game_resources_system.get_resource("mana")
	return card.data.cost <= mana


func _on_hand_card_created(card:Card) -> void:
	card.is_playable = can_afford_card(card)
	print(card)
	print(card.is_playable)


func _on_card_gameplay_system_card_created_with_key(key:String, card:Card) -> void:
	var unit := player_units[key]
	var context: CardContext = CardContext.new()
	context.battle = self
	context.unit = unit
	card.context = context

	
