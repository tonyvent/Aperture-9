extends ColorRect
class_name StaticOverlay

## Placeholder for the static flicker effect when switching cameras.

func flash() -> void:
    visible = true
    await get_tree().create_timer(0.1).timeout
    visible = false
