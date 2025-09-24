extends Node
class_name ProfileManager

## Autoload that manages persistent player progress and statistics.

const PROFILE_PATH := "user://profile.json"

var best_score: Dictionary = {}
var last_camera_index: int = 0
var totals: Dictionary = {
    "matches": {
        "correct": 0,
        "false": 0,
        "missed": 0,
    },
    "photos": {
        "good": 0,
        "total": 0,
    },
}

func _ready() -> void:
    load_profile()

func load_profile() -> void:
    if not FileAccess.file_exists(PROFILE_PATH):
        save_profile()
        return

    var file: FileAccess = FileAccess.open(PROFILE_PATH, FileAccess.READ)
    var result: Variant = JSON.parse_string(file.get_as_text())
    if typeof(result) != TYPE_DICTIONARY:
        push_warning("Profile data was not a dictionary; resetting to defaults.")
        save_profile()
        return

    best_score = result.get("best_score", best_score)
    last_camera_index = int(result.get("last_camera_index", last_camera_index))
    var totals_value: Variant = result.get("totals", null)
    if totals_value is Dictionary:
        totals = totals_value

func save_profile() -> void:
    var file: FileAccess = FileAccess.open(PROFILE_PATH, FileAccess.WRITE)
    var data: Dictionary = {
        "best_score": best_score,
        "last_camera_index": last_camera_index,
        "totals": totals,
    }
    file.store_string(JSON.stringify(data, "\t"))

func update_best_score(difficulty: String, score: int) -> void:
    var current_best: int = int(best_score.get(difficulty, 0))
    if score > current_best:
        best_score[difficulty] = score
        save_profile()

func record_camera_index(index: int) -> void:
    last_camera_index = index
    save_profile()

func record_match_result(result_type: String) -> void:
    var matches: Dictionary = totals.get("matches", {})
    if not matches.has(result_type):
        push_warning("Unknown match result type: %s" % result_type)
        return
    matches[result_type] = int(matches[result_type]) + 1
    totals["matches"] = matches
    save_profile()

func record_photo(good: bool) -> void:
    var photos: Dictionary = totals.get("photos", {})
    photos["total"] = int(photos.get("total", 0)) + 1
    if good:
        photos["good"] = int(photos.get("good", 0)) + 1
    totals["photos"] = photos
    save_profile()
