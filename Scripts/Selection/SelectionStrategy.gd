## Interface for selection logic. Must be extended.
extends Resource
class_name SelectionStrategy

func _select(context: CardContext, _spec: SelectionSpec , controller: Node) -> Array:
    push_error("SelectionStrategy._select not implemented")
    return []


static func _matches_team_mask(caster: Node, target: Node, mask: int) -> bool:
    if caster == target:
        return (mask & SelectionSpec.TeamMask.CASTER) != 0
    var caster_team: Team = _get_team(caster)
    var target_team: Team = _get_team(target)
    if target_team == null or caster_team == null:
        return (mask & SelectionSpec.TeamMask.NEUTRAL) != 0
    var rel: Team.RelativeRelation = caster_team.get_relative_relation(target_team.faction)
    return (rel == Team.RelativeRelation.ALLIED     and (mask & SelectionSpec.TeamMask.ALLY)    != 0) \
        or (rel == Team.RelativeRelation.ENEMIES    and (mask & SelectionSpec.TeamMask.ENEMY)   != 0) \
        or (rel == Team.RelativeRelation.INDIFFERENT and (mask & SelectionSpec.TeamMask.NEUTRAL) != 0)

static func _get_team(node: Node) -> Team:
    var t := node.get_node_or_null("Team")
    if t is Team: return t
    for child in node.get_children():
        if child is Team: return child
    return null