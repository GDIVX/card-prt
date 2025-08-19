# res://cards/selection/SelectionSpec.gd
extends Resource
class_name SelectionSpec

enum TeamMask {
    CASTER  = 1,
    ALLY    = 1 << 1,
    ENEMY   = 1 << 2,
    NEUTRAL = 1 << 3,
}

@export_flags("Caster", "Ally", "Enemy", "Neutral")
var team_mask: int = TeamMask.ALLY | TeamMask.ENEMY

enum SelectionMode { CURSOR, AUTO_AROUND_CASTER }
@export var mode: SelectionMode = SelectionMode.CURSOR

@export_category("Behavior")
@export var strategy: SelectionStrategy
@export var visualScene: PackedScene = preload("res://Scenes/Selection/selection_view.tscn")

@export_category("Limits")
@export var max_targets: int = 1
@export var max_range: float = 600.0
