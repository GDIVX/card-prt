## Data object used to configure [SelectionStrategy]
extends Resource
class_name SelectionSpec

enum TeamMask {
    CASTER  = 1, ## The unit that cast the effect
    ALLY    = 1 << 1, ## Allies to the caster
    ENEMY   = 1 << 2, ## Enemies to the caster
    NEUTRAL = 1 << 3, ## Neutral entities
}

@export_flags(
    "Caster", ## The unit that cast the effect
    "Ally",## Allies to the caster
    "Enemy",## Enemies to the caster
    "Neutral",)## Neutral entities
var team_mask: int = TeamMask.ALLY | TeamMask.ENEMY

enum SelectionMode 
{
     CURSOR,
      AUTO_AROUND_CASTER
}
@export var mode: SelectionMode = SelectionMode.CURSOR

@export_category("Behavior")
@export var strategy: SelectionStrategy
@export var visualScene: PackedScene = preload("res://Scenes/Selection/selection_view.tscn")

@export_category("Limits")
@export var max_targets: int = 1
@export var min_targets: int = 1
@export var max_range: float = 600.0
