extends Control

@onready var hand_tracking: CheckButton = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/hand_tracking
@onready var mode_selected: Sprite2D = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/ModeSelected
@onready var list_cameras: VBoxContainer = $PanelContainer/MarginContainer/VBoxContainer/ListCameras
@onready var music_slider: HSlider = $PanelContainer/MarginContainer/VBoxContainer/Spacer/MusicSlider



var go_back_to := ""

signal volume_changed(value: float)

func _ready() -> void:
	hand_tracking.button_pressed = true
	hand_tracking_mode();
	pass

func hand_tracking_mode( button_is_checked: bool = hand_tracking.button_pressed ):
	GameMaster.set_mouse_mode(button_is_checked)
	update_mode_icon(!button_is_checked)

func update_mode_icon(is_hand: bool):
	mode_selected.texture = preload("res://assets/sprites/HUD/hand_settings_icon.png") if is_hand else preload("res://assets/sprites/HUD/mouse_settings_icon.png")

func populate_camera_buttons(container: VBoxContainer) -> void:
	for child in container.get_children():
		child.queue_free()

	var cameras = Udp.available_cameras
	var group := ButtonGroup.new()
	
	if cameras.is_empty():
		var label := Label.new()
		label.text = "Aucune caméra détectée"
		container.add_child(label)
		return

	for camera in cameras:
		var camera_index := int(camera["index"])

		var button := CheckBox.new()
		button.text = camera["name"]
		button.button_group = group
		button.button_pressed = camera_index == GameMaster.hand_tracking_camera_index

		button.pressed.connect(func():
			GameMaster.restart_hand_tracking(camera_index)
		)

		container.add_child(button)



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


func _on_music_slider_value_changed(value: float) -> void:
	volume_changed.emit(value)
