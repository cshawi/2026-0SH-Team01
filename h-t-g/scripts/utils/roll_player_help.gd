extends Control
class_name RollPlayerHelp

@onready var message_display: MessageDisplay = $MessageDisplay
@onready var timer: Timer = $Timer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	timer.wait_time = message_display.text.length()
	hide_message()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func set_message(message: String):
	message_display.set_message(message)
	
func show_message():
	show()
	message_display.show_message()
	timer.start()
	
func hide_message():
	hide()
	message_display.hide_message()


func _on_timer_timeout() -> void:
	hide_message()
