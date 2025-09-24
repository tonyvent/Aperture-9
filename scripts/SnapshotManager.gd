extends Node
class_name SnapshotManager

## Evaluates screenshots taken during a shift.

signal snapshot_taken(score: int)

func capture_snapshot(subject: Dictionary) -> void:
    # Placeholder scoring logic. Real implementation will consider framing,
    # timing, and target accuracy.
    var score := 10 if subject.is_empty() == false else 0
    snapshot_taken.emit(score)
    ProfileManager.record_photo(score > 0)
