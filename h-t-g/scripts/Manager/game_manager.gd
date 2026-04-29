extends Node2D
class_name GameManager


@export var world_map := "res://scenes/Levels/World_map/world_map.tscn"
@export_file("*.ogg") var world_music: String
@export_file("*.ogg") var menu_music: String
@export var music_fade_duration := 1.0

@onready var previous_music: AudioStreamPlayer = $PreviousMusic
@onready var next_music: AudioStreamPlayer = $NextMusic

#python
var hand_tracking_pid := -1
const HAND_TRACKING_NAME := "hand_tracking"
const HAND_TRACKING_DEBUG_NAME := "hand_tracking_debug"


var current_music_path := ""
var active_music_player: AudioStreamPlayer
var inactive_music_player: AudioStreamPlayer
var mouse_mode := true #temporaire le temps d'avoir les paramètres
var player_hp: float
var magic_cursor: MagicCursor

signal mouse_mode_changed

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	start_hand_tracking()

	active_music_player = previous_music
	inactive_music_player = next_music

	previous_music.finished.connect(_on_music_finished.bind(previous_music))
	next_music.finished.connect(_on_music_finished.bind(next_music))
	transition_to_music(menu_music)



# Called every frame. 'delta' is the elapsed time since the previous frame.
@warning_ignore("unused_parameter")
func _process(delta: float) -> void:
	pass

func start_hand_tracking() -> void:

	if hand_tracking_pid != -1:
		return

	var exe_path := get_hand_tracking_path()

	if not FileAccess.file_exists(exe_path):
		push_warning("hand_tracking.exe introuvable: " + exe_path)
		return

	hand_tracking_pid = OS.create_process(exe_path, [])

	if hand_tracking_pid == -1:
		push_warning("Impossible de lancer hand_tracking.exe")

func stop_hand_tracking() -> void:
	if hand_tracking_pid != -1:
		OS.kill(hand_tracking_pid)
		hand_tracking_pid = -1

	if OS.has_feature("windows"):
		OS.execute("taskkill", ["/IM", get_hand_tracking_filename(false), "/F"], [], false, true)
		OS.execute("taskkill", ["/IM", get_hand_tracking_filename(true), "/F"], [], false, true)

	elif OS.has_feature("macos") or OS.has_feature("linux"):
		OS.execute("pkill", ["-f", HAND_TRACKING_NAME], [], false, true)



func _notification(what: int) -> void:
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		stop_hand_tracking()
		get_tree().quit()

func get_hand_tracking_filename(debug := false) -> String:
	var file_name := HAND_TRACKING_DEBUG_NAME if debug else HAND_TRACKING_NAME

	if OS.has_feature("windows"):
		file_name += ".exe"

	return file_name

func get_hand_tracking_path() -> String:
	if OS.has_feature("editor"):
		var debug_file := get_hand_tracking_filename(true)
		return ProjectSettings.globalize_path("res://../ht-udp/dist/" + debug_file)

	var release_file := get_hand_tracking_filename(false)
	return OS.get_executable_path().get_base_dir().path_join(release_file)



func register_level(level: Node) -> void:
	if level.has_signal("level_finished") and not level.level_finished.is_connected(on_level_finished):
		level.level_finished.connect(on_level_finished)
	if level.has_player:
		Hud.set_player_connection(level.player.get_node("HealthComponent"))
		Hud.show_player_control()

func set_mouse_mode(new_mode: bool):
	mouse_mode = new_mode
	mouse_mode_changed.emit(new_mode)

func on_level_finished(): #reçoit player.current_hp en paramètre
	await Fade_transition.play_transition(GameMaster.change_to_level, world_map)
	
func change_to_level(path: String) -> void: #passe de la carte du monde au niveau choisi
	get_tree().change_scene_to_file(path)
	await get_tree().process_frame
	
func transition_to_music(music_path: String) -> void:
	if music_path == "" or music_path == current_music_path:
		return

	current_music_path = music_path

	var stream := load(music_path)
	if stream == null:
		return

	var old_player := active_music_player
	var new_player := inactive_music_player

	new_player.stream = stream
	new_player.volume_db = 0.0
	new_player.play()

	active_music_player = new_player
	inactive_music_player = old_player

	var tween := create_tween()
	tween.tween_property(old_player, "volume_db", -40.0, music_fade_duration)
	tween.parallel().tween_property(new_player, "volume_db", 0.0, music_fade_duration)

	tween.finished.connect(func():
		old_player.stop()
		old_player.stream = null
	)

func _on_music_finished(player: AudioStreamPlayer) -> void:
	if player != active_music_player:
		return

	if player.stream == null:
		return

	await get_tree().create_timer(5.0).timeout

	if player != active_music_player:
		return

	if player.stream == null:
		return

	player.play()
