extends Node
class_name Team

@export var faction: Faction

enum Faction {PLAYER, ENEMY, NEUTRAL}
enum RelativeRelation {ALLIED, ENEMIES, INDIFFERENT}

func get_relative_relation(other_faction: Faction) -> RelativeRelation:
    # Neutral team is indifferent towards anyone, including itself
    if faction == Faction.NEUTRAL or other_faction == Faction.NEUTRAL:
        return RelativeRelation.INDIFFERENT

    if faction == other_faction :
         return RelativeRelation.ALLIED

    # Since they are not allies or neutral, they must be enemies
    return RelativeRelation.ENEMIES

    
