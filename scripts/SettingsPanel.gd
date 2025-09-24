extends Control
class_name SettingsPanel

## Simple surface for adjusting placeholder settings.

@onready var difficulty_option: OptionButton = $MarginContainer/VBoxContainer/DifficultyRow/DifficultyOption
@onready var crowd_slider: HSlider = $MarginContainer/VBoxContainer/CrowdRow/CrowdSlider
@onready var fullscreen_checkbox: CheckBox = $MarginContainer/VBoxContainer/FullscreenRow/FullscreenCheckBox

const DIFFICULTIES := ["Easy", "Normal", "Hard", "Nightmare"]

func _ready() -> void:
    visible = false
    _populate_difficulty()
    _sync_from_settings()
    difficulty_option.item_selected.connect(_on_difficulty_selected)
    crowd_slider.value_changed.connect(_on_crowd_changed)
    fullscreen_checkbox.toggled.connect(_on_fullscreen_toggled)

func _populate_difficulty() -> void:
    difficulty_option.clear()
    for difficulty in DIFFICULTIES:
        difficulty_option.add_item(difficulty)

func _sync_from_settings() -> void:
    var index := DIFFICULTIES.find(GameSettings.difficulty)
    if index == -1:
        index = DIFFICULTIES.find("Normal")
    difficulty_option.select(max(0, index))
    crowd_slider.value = GameSettings.crowd_size
    fullscreen_checkbox.button_pressed = GameSettings.full_screen

func _on_difficulty_selected(index: int) -> void:
    GameSettings.set_difficulty(difficulty_option.get_item_text(index))

func _on_crowd_changed(value: float) -> void:
    GameSettings.set_crowd_size(int(value))

func _on_fullscreen_toggled(pressed: bool) -> void:
    GameSettings.set_full_screen(pressed)
