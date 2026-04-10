extends Control

const tutorial_path = "res://scenes/world_tomy.tscn"
const settings_path = "res://scenes/menu/settings.tscn"



func _ready() -> void:
	
	pass	
func change_scene(scene_path:String ):
	await Fade_transition.play_transition(GameMaster.change_to_level,scene_path)
	

func _on_button_pressed() -> void:
	change_scene(tutorial_path)


func _on_settings_pressed() -> void:
	get_tree().change_scene_to_file(settings_path)
	


func _on_exit_pressed() -> void:
	#save player stats 
	get_tree().quit()
