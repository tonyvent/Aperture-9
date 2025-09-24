extends Node
class_name CameraNetwork

## Handles switching between the nine surveillance cameras.

signal active_camera_changed(index: int)

@export var camera_count := 9
var _active_index := 0

func _ready() -> void:
    active_camera_changed.emit(_active_index)

func activate_next() -> void:
    set_active((_active_index + 1) % camera_count)

func activate_previous() -> void:
    set_active((_active_index - 1 + camera_count) % camera_count)

func set_active(index: int) -> void:
    index = clamp(index, 0, camera_count - 1)
    if index == _active_index:
        return
    _active_index = index
    active_camera_changed.emit(_active_index)
    ProfileManager.record_camera_index(_active_index)

func get_active() -> int:
    return _active_index
