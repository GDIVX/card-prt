## Always return the caster unit as the only element in the array
class_name SelfSelection
extends SelectionStrategy

func _select(context: CardContext, _spec: SelectionSpec , _controller: SelectionController) -> Array:
    return [context.unit]