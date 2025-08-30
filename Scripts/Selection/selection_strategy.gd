## Strategy resource for selecting targets.
##
## Pluggable selection logic used by the selection system to decide which nodes become targets.[br]
## Implementations override [member _select] to return an [Array] of targets using [annotation CardContext] and [annotation SelectionSpec].[br]
##[br]
## See also: [SelectionController], [SelectionView], [SelectionSpec], [Team].[br]
extends Resource
class_name SelectionStrategy

## Perform selection and return the resulting targets.
##[br]
## Called by [SelectionController] when a selection session resolves (click, auto-pick, etc.).[br]
## Should be pure logic: input and visuals are handled by controller/view.[br]
## Returns: [Array] of [Node] targets (empty is valid).[br]
## Parameters: [b]context[/b] ([CardContext]), [b]spec[/b] ([SelectionSpec]), [b]controller[/b] ([SelectionController]).
func _select(_context: CardContext, _spec: SelectionSpec, _controller: Node) -> Array:
	push_error("SelectionStrategy._select not implemented")
	return []


## Check if [param target] matches the team mask relative to [param caster].
##[br]
## If [code]caster == target[/code], requires [SelectionSpec.TeamMask.CASTER].[br]
## If either side lacks [Team], treated as neutral and requires [enum SelectionSpec.TeamMask] to be [b]NEUTRAL[/b].[br]
## Otherwise compares [method Team.get_relative_relation] against [b]ALLY[/b], [b]ENEMY[/b], [b]NEUTRAL[/b].[br]
## Returns: [bool].
static func _matches_team_mask(caster: Node, target: Node, mask: int) -> bool:
	if caster == target:
		return (mask & SelectionSpec.TeamMask.CASTER) != 0
	var caster_team: Team = _get_team(caster)
	var target_team: Team = _get_team(target)
	if target_team == null or caster_team == null:
		return (mask & SelectionSpec.TeamMask.NEUTRAL) != 0
	var rel: Team.RelativeRelation = caster_team.get_relative_relation(target_team.faction)
	return (rel == Team.RelativeRelation.ALLIED      and (mask & SelectionSpec.TeamMask.ALLY)    != 0) \
	    or (rel == Team.RelativeRelation.ENEMIES     and (mask & SelectionSpec.TeamMask.ENEMY)   != 0) \
	    or (rel == Team.RelativeRelation.INDIFFERENT and (mask & SelectionSpec.TeamMask.NEUTRAL) != 0)


## Resolve a [annotation Team] component from a node.
##[br]
## Looks for a child [Node] named [u]Team[/u], then scans direct children for a [Team] instance.[br]
## Returns: [Team] or [code]null[/code].
static func _get_team(node: Node) -> Team:
	var t := node.get_node_or_null("Team")
	if t is Team:
		return t
	for child in node.get_children():
		if child is Team:
			return child
	return null
