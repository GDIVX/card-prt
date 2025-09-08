## An abstract class that implement the strategy pattern that represent card behavior 
class_name CardEffect
extends Resource

func apply(_card: Card, _targets: Array) -> void:
    pass #replace with implementation

## Returns a structured description for this effect.
## If this returns null, the card falls back to `CardStyle.Description`.
##[br]
## How to implement:
## [br]- Create a [DescriptionSpec] and append parts with `add(...)`.
## [br]- Use [method DescriptionSpec.text] for literal text.
## [br]- Use [DescriptionSpec.param(name, provider)] for dynamic values.
##   The provider is a `Callable(context: CardContext) -> Variant` used
##   when the description is rendered.
## [br]- Keep it pure and fast: avoid side effects and heavy queries.
##[br]
## @param _context: CardContext — Supplies `unit`, `battle`, and `selection_spec` if needed by providers.
## @return DescriptionSpec: A spec that can be rendered to a user-facing string.
##[br]
## Example:
## [codeblock]
## func describe(_context: CardContext) -> DescriptionSpec:
##     var spec := DescriptionSpec.new()
##     spec.add(DescriptionSpec.text("Deal "))
##     spec.add(DescriptionSpec.param("damage", func(_): return damage_value))
##     spec.add(DescriptionSpec.text(" damage."))
##     return spec
## [/codeblock]
func describe(_context: CardContext) -> DescriptionSpec:
    return null
