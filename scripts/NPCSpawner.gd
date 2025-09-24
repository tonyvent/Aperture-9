extends Node
class_name NPCSpawner

## Responsible for maintaining the active crowd.

@export var spawn_count := 10
var _spawned_characters: Array = []

func _ready() -> void:
    if Engine.is_editor_hint():
        return
    randomize()
    spawn_count = GameSettings.crowd_size
    populate_crowd()

func populate_crowd() -> void:
    clear_crowd()
    for i in spawn_count:
        _spawned_characters.append({"id": i})

func clear_crowd() -> void:
    _spawned_characters.clear()

func get_random_subject() -> Dictionary:
    if _spawned_characters.is_empty():
        return {}
    return _spawned_characters[randi() % _spawned_characters.size()]
