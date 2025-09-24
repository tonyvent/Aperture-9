extends Node
class_name GameSettings

## Autoload responsible for storing and applying runtime settings.
##
## The current implementation focuses on persisting difficulty, crowd size,
## fullscreen, and audio levels. It intentionally keeps the surface area small
## so the rest of the project can grow around a stable API.

const SETTINGS_PATH := "user://settings.cfg"

var difficulty := "Normal"
var crowd_size := 10
var full_screen := false
var volume_master_db := 0.0
var volume_music_db := -6.0
var volume_sfx_db := -6.0

func _ready() -> void:
    load_settings()
    _apply_video_settings()
    _apply_audio_settings()

func load_settings() -> void:
    var config := ConfigFile.new()
    var result := config.load(SETTINGS_PATH)
    if result != OK:
        save_settings()
        return

    difficulty = config.get_value("game", "difficulty", difficulty)
    crowd_size = int(config.get_value("game", "crowd_size", crowd_size))
    full_screen = bool(config.get_value("video", "full_screen", full_screen))
    volume_master_db = float(config.get_value("audio", "volume_master_db", volume_master_db))
    volume_music_db = float(config.get_value("audio", "volume_music_db", volume_music_db))
    volume_sfx_db = float(config.get_value("audio", "volume_sfx_db", volume_sfx_db))

func save_settings() -> void:
    var config := ConfigFile.new()
    config.set_value("game", "difficulty", difficulty)
    config.set_value("game", "crowd_size", crowd_size)
    config.set_value("video", "full_screen", full_screen)
    config.set_value("audio", "volume_master_db", volume_master_db)
    config.set_value("audio", "volume_music_db", volume_music_db)
    config.set_value("audio", "volume_sfx_db", volume_sfx_db)
    config.save(SETTINGS_PATH)

func apply_and_save() -> void:
    _apply_video_settings()
    _apply_audio_settings()
    save_settings()

func set_full_screen(enabled: bool) -> void:
    full_screen = enabled
    _apply_video_settings()

func set_difficulty(value: String) -> void:
    difficulty = value
    save_settings()

func set_crowd_size(value: int) -> void:
    crowd_size = max(1, value)
    save_settings()

func set_audio_levels(master_db: float, music_db: float, sfx_db: float) -> void:
    volume_master_db = master_db
    volume_music_db = music_db
    volume_sfx_db = sfx_db
    _apply_audio_settings()
    save_settings()

func _apply_video_settings() -> void:
    if full_screen:
        DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
    else:
        DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)

func _apply_audio_settings() -> void:
    var master_bus := AudioServer.get_bus_index("Master")
    if master_bus != -1:
        AudioServer.set_bus_volume_db(master_bus, volume_master_db)

    var music_bus := AudioServer.get_bus_index("Music")
    if music_bus != -1:
        AudioServer.set_bus_volume_db(music_bus, volume_music_db)

    var sfx_bus := AudioServer.get_bus_index("SFX")
    if sfx_bus != -1:
        AudioServer.set_bus_volume_db(sfx_bus, volume_sfx_db)
