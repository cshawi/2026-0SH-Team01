extends Control

@onready var hand_tracking: CheckButton = $PanelContainer/MarginContainer/HBoxContainer/hand_tracking
@onready var mode_selected: Sprite2D = $PanelContainer/MarginContainer/HBoxContainer/ModeSelected

var go_back_to := ""

func _ready() -> void:
	hand_tracking.button_pressed = true
	hand_tracking_mode();
	pass

func hand_tracking_mode( button_is_checked: bool = hand_tracking.button_pressed ):
	GameMaster.set_mouse_mode(button_is_checked)
	update_mode_icon(!button_is_checked)

func update_mode_icon(is_hand: bool):
	mode_selected.texture = preload("res://assets/sprites/HUD/hand_settings_icon.png") if is_hand else preload("res://assets/sprites/HUD/mouse_settings_icon.png")

func _on_back_button_pressed() -> void:
	get_parent().hide_all_menu()

	match go_back_to:
		"menu":
			get_tree().current_scene.set_ui_enabled(true)
			get_tree().current_scene.get_node("CenterContainer/VBoxContainer/Start").grab_focus()
		"pause":
			get_parent().show_pause_menu()


func _on_hand_tracking_toggled(toggled_on: bool) -> void:
	hand_tracking_mode(toggled_on)
