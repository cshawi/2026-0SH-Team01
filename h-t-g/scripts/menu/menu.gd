extends Control

const world_path = "res://scenes/Levels/World_map/world_map.tscn"
const settings_path = "res://scenes/Menu/settings.tscn"
@onready var start: TextureButton = $CenterContainer/VBoxContainer/Start




func _ready() -> void:
	start.grab_focus()

func change_scene(scene_path:String ):
	await Fade_transition.play_transition(GameMaster.change_to_level,scene_path)
	

func set_ui_enabled(is_enabled: bool):
	mouse_filter = Control.MOUSE_FILTER_STOP if is_enabled else Control.MOUSE_FILTER_IGNORE

func _on_button_pressed() -> void:
	change_scene(world_path)


func _on_settings_pressed() -> void:
	set_ui_enabled(false)
	Hud.get_node("settings").go_back_to = "menu"
	Hud.show_settings_menu()
	


func _on_exit_pressed() -> void:
	#save player stats 
	get_tree().quit()
