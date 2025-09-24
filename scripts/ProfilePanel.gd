extends Control
class_name ProfilePanel

## Shows persistent profile information from the ProfileManager.

@onready var best_score_label: Label = $MarginContainer/VBoxContainer/BestScoreLabel
@onready var totals_label: Label = $MarginContainer/VBoxContainer/TotalsLabel

func refresh() -> void:
    var best_score_lines := []
    var difficulties := ProfileManager.best_score.keys()
    difficulties.sort()
    for difficulty in difficulties:
        best_score_lines.append("%s: %s" % [difficulty, ProfileManager.best_score[difficulty]])
    if best_score_lines.is_empty():
        best_score_lines.append("No scores recorded yet.")
    best_score_label.text = "\n".join(best_score_lines)

    var totals := ProfileManager.totals
    var matches := totals.get("matches", {})
    var photos := totals.get("photos", {})
    totals_label.text = "Matches - Correct: %s, False: %s, Missed: %s\nPhotos - Good: %s / %s" % [
        matches.get("correct", 0),
        matches.get("false", 0),
        matches.get("missed", 0),
        photos.get("good", 0),
        photos.get("total", 0),
    ]
