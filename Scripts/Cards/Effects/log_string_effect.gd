## Print line. Require param "line" of type String
class_name PrintLineEffect
extends CardEffect

@export var line: String = "Default line to print"

func apply(_caster, _targets: Array) -> void:
    # I am so happy that I can simply export a variable and use it in the apply method
    # In Unity I had to encapsulate parameters in a dictionary and then extract them because each scriptable object is a singleton
    # Here I can just export the variable and use it directly
    # I can make resources without a file and use them separately - they won't share the same instance
    # This is so much cleaner and easier to understand
    # I love Godot's approach to resources and how it allows for easy data management
    print(line)