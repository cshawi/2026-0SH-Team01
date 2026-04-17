extends CanvasLayer
class_name HUD

@onready var player_control: Control = $PlayerControl
@onready var pause_menu: Control = $PauseMenu
@onready var settings_menu: Control = $settings


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hide_all_menu()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	

func hide_all_menu():
	pause_menu.hide()
	settings_menu.hide()
	player_control.hide()
	
func show_pause_menu():
	get_tree().paused = true
	if GameMaster.magic_cursor != null:
		GameMaster.magic_cursor.set_cursor_active(false)
	hide_all_menu()
	pause_menu.show()
	pause_menu.resume.grab_focus()
	
func show_settings_menu():
	hide_all_menu()
	settings_menu.show()
	settings_menu.hand_tracking.grab_focus()
	
func show_player_control():
	get_tree().paused = false
	if GameMaster.magic_cursor != null:
		GameMaster.magic_cursor.set_cursor_active(true)
	hide_all_menu()
	if get_tree().current_scene.has_player:
		player_control.show()


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("Pause"):
		if not can_pause():
			return
		
		if get_tree().paused:
			if get_tree().current_scene.has_player:
				show_player_control()
		else:
			show_pause_menu()
			
func can_pause() -> bool:
	return not get_tree().current_scene.name == "menu"

	
