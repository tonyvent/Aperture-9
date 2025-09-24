extends Control
class_name PauseMenu

## Basic pause menu shell that can resume gameplay.

@onready var resume_button: Button = $MarginContainer/VBoxContainer/ResumeButton
@onready var settings_button: Button = $MarginContainer/VBoxContainer/SettingsButton
@onready var controls_button: Button = $MarginContainer/VBoxContainer/ControlsButton
@onready var quit_button: Button = $MarginContainer/VBoxContainer/QuitButton

signal resume_requested
signal settings_requested
signal controls_requested
signal quit_requested

func _ready() -> void:
    visible = false
    resume_button.pressed.connect(func() -> void: resume_requested.emit())
    settings_button.pressed.connect(func() -> void: settings_requested.emit())
    controls_button.pressed.connect(func() -> void: controls_requested.emit())
    quit_button.pressed.connect(func() -> void: quit_requested.emit())
