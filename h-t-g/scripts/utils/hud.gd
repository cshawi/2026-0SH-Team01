extends CanvasLayer
class_name HUD

@onready var player_control: Control = $PlayerControl
@onready var pause_menu: Control = $PauseMenu
@onready var settings_menu: Control = $SettingsMenu



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hide_all_menu()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	

func hide_all_menu():
	pause_menu.hide()
	settings_menu.hide()
	
func show_pause_menu():
	pause_menu.show()
	settings_menu.hide()
	
func show_settings_menu():
	pause_menu.hide()
	settings_menu.show()
