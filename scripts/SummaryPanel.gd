extends Control
class_name SummaryPanel

## Displays end-of-shift results.

@onready var label: Label = $MarginContainer/VBoxContainer/SummaryLabel

func show_summary() -> void:
    visible = true
    label.text = "Summary not yet implemented"
