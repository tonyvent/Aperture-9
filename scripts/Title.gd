extends Control
class_name Title

## Simple title screen with a start button stub.

@onready var start_button: Button = $MarginContainer/VBoxContainer/StartButton
@onready var settings_button: Button = $MarginContainer/VBoxContainer/SettingsButton
@onready var quit_button: Button = $MarginContainer/VBoxContainer/QuitButton
@onready var settings_panel: SettingsPanel = $SettingsPanelInstance

func _ready() -> void:
    start_button.pressed.connect(_on_start_pressed)
    settings_button.pressed.connect(_on_settings_pressed)
    quit_button.pressed.connect(_on_quit_pressed)

func _on_start_pressed() -> void:
    get_tree().change_scene_to_file("res://scenes/Main.tscn")

func _on_settings_pressed() -> void:
    settings_panel.visible = not settings_panel.visible

func _on_quit_pressed() -> void:
    get_tree().quit()
