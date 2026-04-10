extends Control

@onready var hand_tracking: CheckButton = $HBoxContainer/hand_tracking


func _ready() -> void:
	hand_tracking_mode();
	pass

func _on_hand_tracking_pressed() -> void:
	hand_tracking_mode()
	pass 


func hand_tracking_mode( button_is_checked: bool = hand_tracking.button_pressed ):
	GameMaster.mouse_mode = button_is_checked
	
