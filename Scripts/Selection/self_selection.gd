class_name SelfSelection
extends SelectionStrategy

func _select(context: CardContext, _spec: SelectionSpec , _controller: Node) -> Array:
    return [context.unit]