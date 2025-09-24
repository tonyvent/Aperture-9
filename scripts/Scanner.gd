extends Node
class_name Scanner

## Simulates holding a scan over a subject until completion.

signal scan_started(subject: Dictionary)
signal scan_completed(subject: Dictionary)

@export var scan_duration_seconds := 3.0
var _scanning := false
var _timer := 0.0
var _subject: Dictionary = {}

func _ready() -> void:
    set_process(false)

func begin_scan(subject: Dictionary) -> void:
    if _scanning:
        return
    _scanning = true
    _subject = subject
    _timer = scan_duration_seconds
    set_process(true)
    scan_started.emit(subject)

func cancel_scan() -> void:
    if not _scanning:
        return
    _scanning = false
    _subject = {}
    _timer = 0.0
    set_process(false)

func _process(delta: float) -> void:
    if not _scanning:
        return
    _timer = max(0.0, _timer - delta)
    if _timer == 0.0:
        _scanning = false
        set_process(false)
        scan_completed.emit(_subject)
        _subject = {}
