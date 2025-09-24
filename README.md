# Aperture Nine

## Elevator Pitch
You are the camera. Nine hard-wired surveillance cameras ring a single city block. HQ issues targets; you scan, identify, and report—balancing accuracy, time pressure, and moral unease.

## Core Loop
1. **Patrol:** Switch between nine fixed cameras (Q/E) and pan, tilt, and zoom to observe the crowds.
2. **Acquire:** Zoom in and scan (F) subjects to generate a match prompt.
3. **Decide:** Confirm (Y) or deny (N) the match within a timer while optionally snapping photos as evidence.
4. **Score:** HQ grades shots and decisions, with an end-of-shift summary tallying performance.
5. **Progress:** Adjust difficulty and crowd settings, and track personal bests and lifetime totals.

## Key Systems
- **Camera Network:** Nine camera mounts arranged in an adjacency loop with static flicker on switch, HUD labeling, and a mini-map highlighting the active camera.
- **Crowd/NPC Spawner:** Configurable crowd size (1–30) with difficulty-driven NPC speed and suspicious dwell time.
- **Target Manager:** Selects a live target from the current crowd and pushes HQ briefs.
- **Scanner:** Requires holding scan while a subject is centered and zoomed; completion time scales with difficulty and triggers the match prompt.
- **Snapshot/Scoring:** Grades photos based on framing and timing, delivering HQ commentary.
- **Timer & Summary:** Default shift is ten minutes; the summary displays photo and match breakdowns with computed score.
- **Settings (Persisted):** Difficulty (Easy, Normal, Hard, Nightmare), crowd size, fullscreen toggle, and master/music/SFX volume sliders.
- **Profile (Persisted):** Best score per difficulty, last camera index, and lifetime totals.
- **Title/Pause/Overlays:** Title screen, pause menu, settings, controls overlay, and profile access.

## Controls (PC Default)
- **Pan/Tilt:** W/S/A/D
- **Zoom:** Right Mouse Button
- **Switch Camera:** Q/E
- **Snapshot:** Left Mouse Button / Space
- **Scan:** F
- **Confirm/Deny:** Y/N
- **Settings:** Tab
- **Pause:** Esc
- **Fullscreen:** F11
- **Controls Overlay:** H

## Scene & File Structure (Godot 4)
- `scenes/Title.tscn` — Title screen (hooks Settings, Profile, Controls overlay)
- `scenes/Main.tscn` — Gameplay scene (CameraNetwork, NPCSpawner, TargetManager, Scanner, HUD, MiniMap, HQPanel, PauseMenu, SummaryPanel, GameManager, StaticOverlay)
- `ui/HUD.tscn` — Camera label, timer, match prompt
- `ui/MiniMap.tscn` — Nine-node map highlighting the current camera
- `ui/StaticOverlay.tscn` — Switching flicker effect
- `ui/PauseMenu.tscn` — Pause options with Controls access
- `ui/SummaryPanel.tscn` — End-of-shift statistics
- `ui/SettingsPanel.tscn` — Difficulty, crowd, video, and audio sliders
- `ui/ControlsOverlay.tscn` — Keybind and gamepad hints
- `ui/ProfilePanel.tscn` — Best scores and totals
- `scripts/CameraNetwork.gd` — Camera switching logic and signals
- `scripts/NPCSpawner.gd` — Crowd spawn and respawn management
- `scripts/TargetManager.gd` — Target selection logic
- `scripts/Scanner.gd` — Scan timing and prompt triggering
- `scripts/SnapshotManager.gd` — Photo capture and scoring
- `scripts/GameManager.gd` — Shift timer, scoring, and summary control
- `scripts/GameSettings.gd` — Autoload settings, persistence, and audio application
- `scripts/ProfileManager.gd` — Autoload profile persistence (JSON)
- `scripts/Title.gd`, `scripts/PauseMenu.gd`, `scripts/HUD.gd`, `scripts/MiniMap.gd`, `scripts/SummaryPanel.gd`, `scripts/SettingsPanel.gd`, `scripts/ControlsOverlay.gd`, `scripts/ProfilePanel.gd`
- `default_bus_layout.tres` — Audio buses for Master, Music, and SFX

## Data & Persistence
- **Settings →** `user://settings.cfg`
  - `game.difficulty`, `game.crowd_size`
  - `video.full_screen`
  - `audio.volume_master_db`, `audio.volume_music_db`, `audio.volume_sfx_db`
- **Profile →** `user://profile.json`
  - `best_score` mapping difficulty to score
  - `last_camera_index`
  - `totals` for matches (correct/false/missed) and photos (good/total)

## Difficulty Settings (Defaults)
- **Easy:** Scan 2.2s, slower NPCs, longer suspicious dwell time
- **Normal:** Scan 3.0s
- **Hard:** Scan 3.6s, faster NPCs, shorter dwell time
- **Nightmare:** Scan 4.2s, fastest NPCs, minimal dwell time

## Audio Routing
Audio buses include Master, Music, and SFX. Settings sliders apply adjustments at runtime, and all values persist between sessions.

## Win/Lose & Scoring
- Shifts end when the timer expires; there is no hard fail state during play.
- Score calculation: `(good photos × 10) + (correct matches × 50) – (false matches × 30)`.
- Summaries display breakdowns and update the profile's best score for the current difficulty.

## Content Placeholders
- **NPCs:** Capsule meshes with basic wandering states (ready to swap for models/animation).
- **Environment:** Simple block layout with adjustable camera mounts.
- **SFX:** Hook shutter and UI bleeps to the SFX bus; optional music routes through the Music bus.

## Roadmap
- Steam-ready polish with achievements, cloud saves, and rich presence.
- Deeper AI behaviors (routes, disguises, multi-camera pursuits).
- Event scripting per camera/zone with escalating HQ directives.
- Photo gallery featuring thumbnails and evidence tags.
- Localization and accessibility, including remappable keys, subtitles, and color-blind-safe UI.
