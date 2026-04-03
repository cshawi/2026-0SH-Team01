extends Control

func _ready() -> void:
	hand_tracking_mode();
	pass

func _on_hand_tracking_pressed() -> void:
	hand_tracking_mode()
	pass 


func hand_tracking_mode( button_is_checked:bool = $hand_tracking.checked ): 	
	GameMaster.mouse_mode = button_is_checked
	
