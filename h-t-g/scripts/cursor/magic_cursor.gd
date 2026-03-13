extends Area2D

@export_group("Visual")
@export var size := 1.0
@export var color : Color

@export_group("Utils")
@export var mouse_mode := true
@export var lerp_weight := 0.15
var is_holding := false

func _ready() -> void:
	initialize_visual()
	
func initialize_visual():
	$CollisionShape2D.scale = Vector2(size, size)
	$PointLight2D.texture_scale = size
	$Sprite2D.scale = Vector2(size, size)
	$CPUParticles2D.emission_sphere_radius = size * 15
	change_color(color)
	
func change_color(new_color):
	$PointLight2D.texture.gradient.set_color(0, new_color)
	$Sprite2D.self_modulate = new_color
	$Sprite2D.self_modulate.a = 0.5
	$CPUParticles2D.color_ramp.set_color(0, new_color.lightened(0.5))

func _process(delta: float) -> void:
	if Udp.is_pinching:
		change_color(Color.RED)
	else:
		change_color(Color.AQUA)
	if mouse_mode:
		mouse()
	else:
		hand_tracking()

func mouse():
	global_position = get_global_mouse_position()
	#if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		#mouse_mode = false

func hand_tracking():
	global_position = global_position.lerp(Udp.hand_position, lerp_weight)
	#if Udp.is_pinching:
		#mouse_mode = true
