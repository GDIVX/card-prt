## Always return an empty array
class_name SkipSelection extends SelectionStrategy

func _select(_context: CardContext, _spec: SelectionSpec , _controller: Node) -> Array:
    return []