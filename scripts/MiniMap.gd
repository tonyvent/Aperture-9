extends Control
class_name MiniMap

## Highlights the currently active camera in the network.

@onready var indicator_container: GridContainer = $MarginContainer/GridContainer

func set_active_camera(index: int) -> void:
    for child_index in indicator_container.get_child_count():
        var child := indicator_container.get_child(child_index)
        if child is Button:
            child.button_pressed = child_index == index
