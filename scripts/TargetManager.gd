extends Node
class_name TargetManager

## Maintains the current HQ-issued target information.

signal target_changed(target: Dictionary)

var _active_target: Dictionary = {}

@onready var npc_spawner: NPCSpawner = get_node_or_null("../NPCSpawner")

func pick_new_target() -> void:
    if not npc_spawner:
        push_warning("TargetManager requires an NPCSpawner sibling.")
        return
    _active_target = npc_spawner.get_random_subject()
    target_changed.emit(_active_target)

func get_active_target() -> Dictionary:
    return _active_target
