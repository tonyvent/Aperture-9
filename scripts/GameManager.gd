extends Node
class_name GameManager

## Coordinates the relationship between the main gameplay systems.

@export var shift_length_seconds := 600.0

var _shift_time_remaining := 0.0
var _shift_active := false

@onready var camera_network: Node = get_node_or_null("CameraNetwork")
@onready var npc_spawner: Node = get_node_or_null("NPCSpawner")
@onready var target_manager: Node = get_node_or_null("TargetManager")
@onready var scanner: Node = get_node_or_null("Scanner")
@onready var snapshot_manager: Node = get_node_or_null("SnapshotManager")
@onready var hud: CanvasItem = get_node_or_null("HUD")
@onready var mini_map: CanvasItem = get_node_or_null("MiniMap")
@onready var static_overlay: CanvasItem = get_node_or_null("StaticOverlay")
@onready var pause_menu: PauseMenu = get_node_or_null("PauseMenu")
@onready var summary_panel: CanvasItem = get_node_or_null("SummaryPanel")
@onready var settings_panel: SettingsPanel = get_node_or_null("SettingsPanel")
@onready var controls_overlay: ControlsOverlay = get_node_or_null("ControlsOverlay")
@onready var profile_panel: ProfilePanel = get_node_or_null("ProfilePanel")

func _ready() -> void:
    _shift_time_remaining = shift_length_seconds
    set_process(true)
    if Engine.is_editor_hint():
        return
    _prepare_ui_state()
    _connect_signals()
    start_shift()

func _process(delta: float) -> void:
    if not _shift_active:
        return
    _shift_time_remaining = max(0.0, _shift_time_remaining - delta)
    if hud:
        hud.call_deferred("update_timer", _shift_time_remaining)
    if _shift_time_remaining == 0.0:
        end_shift()

func start_shift() -> void:
    _shift_time_remaining = shift_length_seconds
    _shift_active = true
    if hud:
        hud.call_deferred("show_gameplay")
    if mini_map:
        mini_map.visible = true
    if static_overlay:
        static_overlay.visible = true
    if profile_panel:
        profile_panel.visible = false
    if summary_panel:
        summary_panel.visible = false

func end_shift() -> void:
    if not _shift_active:
        return
    _shift_active = false
    if summary_panel:
        summary_panel.call_deferred("show_summary")
    if profile_panel:
        profile_panel.visible = true
        profile_panel.call_deferred("refresh")

func toggle_pause() -> void:
    if get_tree().paused:
        _on_resume_requested()
    else:
        get_tree().paused = true
        if pause_menu:
            pause_menu.visible = true

func _prepare_ui_state() -> void:
    if hud:
        hud.call_deferred("show_title")
    for node in [mini_map, static_overlay, pause_menu, summary_panel, settings_panel, controls_overlay, profile_panel]:
        if node:
            node.visible = false

func _connect_signals() -> void:
    if camera_network and mini_map and camera_network.has_signal("active_camera_changed"):
        camera_network.active_camera_changed.connect(mini_map.set_active_camera)
    if pause_menu:
        pause_menu.resume_requested.connect(_on_resume_requested)
        pause_menu.settings_requested.connect(_on_pause_settings_requested)
        pause_menu.controls_requested.connect(_on_pause_controls_requested)
        pause_menu.quit_requested.connect(_on_pause_quit_requested)
    if camera_network and static_overlay and camera_network.has_signal("active_camera_changed") and static_overlay.has_method("flash"):
        camera_network.active_camera_changed.connect(func(_index: int) -> void: static_overlay.flash())

func _on_resume_requested() -> void:
    get_tree().paused = false
    if pause_menu:
        pause_menu.visible = false
    if settings_panel:
        settings_panel.visible = false
    if controls_overlay:
        controls_overlay.visible = false

func _on_pause_settings_requested() -> void:
    if settings_panel:
        settings_panel.visible = not settings_panel.visible

func _on_pause_controls_requested() -> void:
    if controls_overlay:
        controls_overlay.visible = not controls_overlay.visible

func _on_pause_quit_requested() -> void:
    get_tree().quit()
