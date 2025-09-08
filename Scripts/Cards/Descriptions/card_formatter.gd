## Renders DescriptionSpec to strings and builds specs from effects
class_name CardFormatter
extends RefCounted

static func build_spec_from_card(card: Card, context: CardContext) -> DescriptionSpec:
    var spec := DescriptionSpec.new()
    if card == null or card.data == null:
        return spec
    var first := true
    for effect: CardEffect in card.data.card_effects:
        if effect == null:
            continue
        var eff_spec: DescriptionSpec = effect.describe(context)
        if eff_spec != null:
            if not first:
                spec.add(DescriptionSpec.newline())
            spec.concat(eff_spec)
            first = false
    return spec

static func render_for_card(card: Card, context: CardContext) -> String:
    # Prefer spec from effects; fallback to style Description
    var spec := build_spec_from_card(card, context)
    var text := spec.render(context)
    if text.strip_edges() == "" and card and card.data and card.data.card_style:
        return str(card.data.card_style.Description)
    return text
