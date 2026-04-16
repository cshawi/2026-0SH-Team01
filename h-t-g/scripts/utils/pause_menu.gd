extends Control
class_name PauseMenu

@onready var resume: TextureButton = $PanelContainer/MarginContainer/VBoxContainer/Resume

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	

func _on_resume_pressed() -> void:
	get_tree().paused = false
	get_parent().show_player_control()

func _on_settings_pressed() -> void:
	get_parent().get_node("settings").go_back_to = "pause"
	get_parent().show_settings_menu()

func _on_map_pressed() -> void:
	get_tree().paused = false
	get_parent().hide_all_menu()
	await Fade_transition.play_transition(GameMaster.change_to_level, "res://scenes/world_map.tscn")

func _on_menu_pressed() -> void:
	get_tree().paused = false
	get_parent().hide_all_menu()
	await Fade_transition.play_transition(GameMaster.change_to_level, "res://scenes/menu/menu.tscn")

func _on_exit_pressed() -> void:
	get_tree().quit()
