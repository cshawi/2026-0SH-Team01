extends CanvasLayer
class_name FadeTransition

#@onready var color_rect: ColorRect = $ColorRect
@onready var die_transition: ColorRect = $LevelTransition
@onready var level_transition: ColorRect = $DieTransition

@export var fade_duration: float = 0.6
@export var die_duration: float = 0.6
@export var fade_color: Color = Color.BLACK

func _ready() -> void:
	#color_rect.color = fade_color
	#color_rect.modulate.a = 0.0
	show()
	level_transition.hide() 
	die_transition.hide()

#func fade_out() -> void:
	#show()
	#var tween := create_tween()
	#tween.tween_property(color_rect, "modulate:a", 1.0, fade_duration)
	#await tween.finished
#
#func fade_in() -> void:
	#var tween := create_tween()
	#tween.tween_property(color_rect, "modulate:a", 0.0, fade_duration)
	#await tween.finished
	#hide()

func play_transition(action: Callable, p1 = null) -> void:
	await fade_out_dead()
	await action.call(p1) if p1 else await action.call()  #reçoit la fonction à exécuter après le fade
	await fade_in_dead()

func fade_out_dead() -> void:
	die_transition.show()
	die_transition.material.set_shader_parameter("luminance_cutoff", 0.0)
	die_transition.material.set_shader_parameter("invert", true)
	var tween := create_tween()
	tween.tween_property(die_transition.material, "shader_parameter/luminance_cutoff", 1.0, die_duration)
	await tween.finished

func fade_in_dead() -> void:
	die_transition.material.set_shader_parameter("luminance_cutoff", 0.0)
	die_transition.material.set_shader_parameter("invert", false)
	var tween := create_tween()
	tween.tween_property(die_transition.material, "shader_parameter/luminance_cutoff", 1.0, die_duration)
	await tween.finished
	die_transition.hide()
