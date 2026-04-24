extends CanvasLayer
class_name FadeTransition

@onready var color_rect: ColorRect = $ColorRect

@export var fade_duration: float = 0.25
@export var fade_color: Color = Color.BLACK

func _ready() -> void:
	color_rect.color = fade_color
	color_rect.modulate.a = 0.0
	hide()

func fade_out() -> void:
	show()
	var tween := create_tween()
	tween.tween_property(color_rect, "modulate:a", 1.0, fade_duration)
	await tween.finished

func fade_in() -> void:
	var tween := create_tween()
	tween.tween_property(color_rect, "modulate:a", 0.0, fade_duration)
	await tween.finished
	hide()

func play_transition(action: Callable, p1 = null) -> void:
	await fade_out()
	await action.call(p1) if p1 else await action.call()  #reçoit la fonction à exécuter après le fade
	await fade_in()
