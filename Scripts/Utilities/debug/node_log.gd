extends Label

@export var log_name := true
@export var log_children := false



func log(node : Node) -> void:
    var str := ""
    if log_name: str += node.name

    if log_children:
        for child in node.get_children():
            str += "\n " + child.name

    text = str
        
