extends CanvasLayer
class_name FadeTransition

@onready var base_transition: ColorRect = $BaseTransition
@onready var die_transition: ColorRect = $DieTransition
@onready var level_transition: ColorRect = $LevelTransition

@export var base_duration: float = 0.4
@export var level_duration: float = 0.6
@export var die_duration: float = 0.6
@export var fade_color: Color = Color.BLACK

func _ready() -> void:
	#color_rect.color = fade_color
	#color_rect.modulate.a = 0.0
	show()
	base_transition.hide()
	level_transition.hide() 
	die_transition.hide()

func fade_out() -> void:
	base_transition.show()
	var tween := create_tween()
	tween.tween_property(base_transition, "modulate:a", 1.0, base_duration)
	await tween.finished

func fade_in() -> void:
	var tween := create_tween()
	tween.tween_property(base_transition, "modulate:a", 0.0, base_duration)
	await tween.finished
	base_transition.hide()

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
func fade_out_level() -> void:
	level_transition.show()
	level_transition.material.set_shader_parameter("luminance_cutoff", 0.0)
	level_transition.material.set_shader_parameter("invert", true)
	var tween := create_tween()
	tween.tween_property(level_transition.material, "shader_parameter/luminance_cutoff", 1.0, level_duration)
	await tween.finished

func fade_in_level() -> void:
	level_transition.material.set_shader_parameter("luminance_cutoff", 0.0)
	level_transition.material.set_shader_parameter("invert", false)
	var tween := create_tween()
	tween.tween_property(level_transition.material, "shader_parameter/luminance_cutoff", 1.0, level_duration)
	await tween.finished
	level_transition.hide()

func play_transition(action: Callable, p1 = null) -> void:
	await fade_out()
	await action.call(p1) if p1 else await action.call()  #reçoit la fonction à exécuter après le fade
	await fade_in()

func play_level_transition(action: Callable, p1 = null) -> void:
	await fade_out_level()
	await action.call(p1) if p1 else await action.call()  #reçoit la fonction à exécuter après le fade
	await fade_in_level()

func play_dead_transition(action: Callable, p1 = null) -> void:
	await fade_out_dead()
	await action.call(p1) if p1 else await action.call()  #reçoit la fonction à exécuter après le fade
	await fade_in_dead()
