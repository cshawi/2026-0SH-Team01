extends Label
class_name HealLabel

@export var speed := 25.0

func setup(amount : int):
	text = "+" + str(amount)

func _process(delta: float) -> void:
	global_position.y -= speed * delta

func _on_timer_timeout() -> void:
	queue_free()
