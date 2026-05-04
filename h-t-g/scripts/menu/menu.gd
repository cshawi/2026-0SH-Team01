extends Control

const world_path = "res://scenes/Levels/World_map/world_map.tscn"
const settings_path = "res://scenes/Menu/settings.tscn"
@onready var start: TextureButton = $CenterContainer/VBoxContainer/Start
@onready var center_container: CenterContainer = $CenterContainer #boutons
@onready var spinner: AnimatedSprite2D = $Spinner

var is_ready := false

func _ready() -> void:
	GameMaster.completed_levels = []
	spinner.hide()

	if GameMaster.cam_loaded:
		center_container.show()
		start.grab_focus()
		return

	center_container.hide()
	spinner.show()
	spinner.play()

	if not Udp.cameras_cached.is_connected(_on_cameras_cached):
		Udp.cameras_cached.connect(_on_cameras_cached)

	Udp.cache_available_cameras_async()

func change_scene(scene_path:String ):
	await Fade_transition.play_level_transition(GameMaster.change_to_level,scene_path)
	

func set_ui_enabled(is_enabled: bool):
	mouse_filter = Control.MOUSE_FILTER_STOP if is_enabled else Control.MOUSE_FILTER_IGNORE

func _on_button_pressed() -> void:
	GameMaster.transition_to_music(GameMaster.world_music)
	change_scene(world_path)


func _on_settings_pressed() -> void:
	set_ui_enabled(false)
	Hud.get_node("settings").go_back_to = "menu"
	Hud.show_settings_menu()
	


func _on_exit_pressed() -> void:
	GameMaster.stop_hand_tracking()
	get_tree().quit()
	
func _on_cameras_cached() -> void:
	if is_ready:
		return

	is_ready = true
	GameMaster.cam_loaded = true

	GameMaster.start_hand_tracking()
	spinner.stop()
	spinner.hide()
	center_container.show()
	start.grab_focus()


	
