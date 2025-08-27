class_name ObservableNumber extends Node

signal value_changed(value:int)

@export var value:int:
    set(new_value):
        value = new_value
        value_changed.emit(new_value)