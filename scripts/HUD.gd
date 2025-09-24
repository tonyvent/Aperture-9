extends Control
class_name HUD

## Displays core gameplay information like the timer and prompts.

@onready var timer_label: Label = $MarginContainer/VBoxContainer/TimerLabel
@onready var message_label: Label = $MarginContainer/VBoxContainer/MessageLabel

func show_title() -> void:
    message_label.text = "Awaiting HQ directive"
    timer_label.text = format_time(0.0)

func show_gameplay() -> void:
    message_label.text = "Shift live"

func update_timer(time_remaining: float) -> void:
    timer_label.text = format_time(time_remaining)

func format_time(time_remaining: float) -> String:
    var seconds := int(round(time_remaining))
    var minutes := seconds / 60
    var secs := seconds % 60
    return "%02d:%02d" % [minutes, secs]
