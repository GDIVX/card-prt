## Data object used to configure [SelectionStrategy]
extends Resource
class_name SelectionSpec

@export var relation_mask: Team.RelativeRelation

## Determine the shape and positional logic of the selection
enum SelectionMode 
{
    ## Center the selection method on the mouse position
    CURSOR,
    ## Center on the caster and immediately fire
    CENTER_ON_CASTER,
    ## Center one end on the caster, and use the mouse as a second point
    FROM_CASTER_TO_MOUSE
}
## Determine the shape and positional logic of the selection
@export var mode: SelectionMode = SelectionMode.CURSOR

@export_category("Behavior")
@export var strategy: SelectionStrategy
@export var visualScene: PackedScene = preload("res://Scenes/Selection/selection_view.tscn")

@export_category("Limits")
## The selection would stop after finding this many targets
@export var max_targets: int = 1 
## The selection would not be accepted if there are not at least this many targets
@export var min_targets: int = 1 
 ## How many times should the selection process should happen before concluding. Use this to spawn multiple rays or regions that are not connected
@export var repeats : int = 1
## The maximum distance away from the caster [TacticalUnit] that is valid for selection. Ignore mouse input that is further that this.
@export var max_range: float = 600.0 

@export_category("Entities")
@export var required_nodes : Array[NodePath] = [
    "Health",
]