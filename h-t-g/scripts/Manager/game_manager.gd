extends Node2D
class_name GameManager


@export var world_map := "res://scenes/Levels/World_map/world_map.tscn"
@export_file("*.ogg") var world_music: String
@export_file("*.ogg") var menu_music: String
@export var music_fade_duration := 1.0
@export var hand_tracking_camera_index := 0


@onready var previous_music: AudioStreamPlayer = $PreviousMusic
@onready var next_music: AudioStreamPlayer = $NextMusic

#python
var hand_tracking_pid := -1
var cam_loaded := false

var current_music_path := ""
var active_music_player: AudioStreamPlayer
var inactive_music_player: AudioStreamPlayer
var mouse_mode := true #temporaire le temps d'avoir les paramètres
var player_hp: float
var magic_cursor: MagicCursor
var music_volume: float
var completed_levels: Array[String] = []

signal mouse_mode_changed

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	active_music_player = previous_music
	inactive_music_player = next_music
	
	Hud.settings_menu.volume_changed.connect(_on_volume_changed)
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

	var exe_path = Udp.get_hand_tracking_path()

	if not FileAccess.file_exists(exe_path):
		push_warning("hand_tracking.exe introuvable: " + exe_path)
		return

	hand_tracking_pid = OS.create_process(exe_path, ["--camera", str(hand_tracking_camera_index)])

	if hand_tracking_pid == -1:
		push_warning("Impossible de lancer hand_tracking")

func restart_hand_tracking(camera_index: int) -> void:
	hand_tracking_camera_index = camera_index
	stop_hand_tracking()
	start_hand_tracking()

func stop_hand_tracking() -> void:
	if hand_tracking_pid != -1:
		OS.kill(hand_tracking_pid)
		hand_tracking_pid = -1

	if OS.has_feature("windows"):
		OS.execute("taskkill", ["/IM", Udp.get_hand_tracking_filename(false), "/F"], [], false, true)
		OS.execute("taskkill", ["/IM", Udp.get_hand_tracking_filename(true), "/F"], [], false, true)

	elif OS.has_feature("macos") or OS.has_feature("linux"):
		OS.execute("pkill", ["-f", Udp.HAND_TRACKING_NAME], [], false, true)

func _notification(what: int) -> void:
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		stop_hand_tracking()
		get_tree().quit()
		
func is_hand_tracking_running() -> bool:
	return hand_tracking_pid != -1


func register_level(level: Node) -> void:
	if level.has_signal("level_finished") and not level.level_finished.is_connected(on_level_finished):
		level.level_finished.connect(on_level_finished)
	if level.has_enemy:
		Hud.set_player_connection(level.player.get_node("HealthComponent"))
		Hud.show_player_control()

func set_mouse_mode(new_mode: bool):
	mouse_mode = new_mode
	mouse_mode_changed.emit(new_mode)

func on_level_finished():
	var completed_level_path := get_tree().current_scene.scene_file_path
	register_completed_level(completed_level_path)

	transition_to_music(world_music)
	await Fade_transition.play_level_transition(GameMaster.change_to_level, world_map)

func register_completed_level(scene_path: String) -> void:
	if scene_path == "":
		return

	var uid := ResourceLoader.get_resource_uid(scene_path)

	if uid == -1:
		return

	var uid_text := ResourceUID.id_to_text(uid)

	if not completed_levels.has(uid_text):
		completed_levels.append(uid_text)


func change_to_level(path: String) -> void: #passe de la carte du monde au niveau choisi
	get_tree().change_scene_to_file(path)
	await get_tree().process_frame
	

func _on_volume_changed(value: float):
	music_volume = value
	active_music_player.volume_db = value

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
	new_player.volume_db = music_volume
	new_player.play()

	active_music_player = new_player
	inactive_music_player = old_player

	var tween := create_tween()
	tween.tween_property(old_player, "volume_db", -40.0, music_fade_duration)
	tween.parallel().tween_property(new_player, "volume_db", music_volume, music_fade_duration)

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
