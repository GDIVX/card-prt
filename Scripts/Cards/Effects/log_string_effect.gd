## Print line. Require param "line" of type String
## 
## Note: In Godot, exporting variables allows each resource instance to have its own data,
## unlike Unity's ScriptableObjects, which are singletons and require parameter encapsulation.
## This approach enables cleaner, more understandable, and flexible data management.
class_name PrintLineEffect
extends CardEffect

@export var line: String = "Default line to print"

## Applies the effect by printing the specified line.
## @param _caster The entity casting the effect.
## @param _targets The array of target entities.
func apply(_card, _targets: Array) -> void:
    # Print the exported line
    print(line)