class_name MagicCursor
extends Area2D

@export_group("Visual")
@export var size := 1.0
@export var color : Color

@export_group("Utils")
@export var mouse_mode := true
@export var lerp_weight := 0.15

var is_active := true
var is_holding := false
var is_grabing := false
var closest_object = null
var first_time := true
var default_strength = 10 #si le joueur ne fait pas partie de la scène

const MAX_INT = (1 << 63) - 1


func _ready() -> void:
	GameMaster.magic_cursor = self
	initialize_visual()
	GameMaster.mouse_mode_changed.connect(_on_mouse_mode_changed)
	_on_mouse_mode_changed(GameMaster.mouse_mode)
	apply_input_mode()
	
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
	if not is_active || get_tree().paused:
		return
		
	if Udp.is_pinching if not mouse_mode else Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		if first_time:
			is_grabing = true
			grab_object()
			first_time = false
		change_color(Color.RED)
	else:
		resetObject();
		change_color(Color.AQUA)
		first_time = true
		
	if mouse_mode:
		mouse()
	else:
		hand_tracking()

func resetObject():
	is_grabing = false
	
	if not is_holding: return
	is_holding = false
	
	
	if closest_object:
		closest_object.desactivate()
		closest_object = null

func mouse():
	global_position = get_global_mouse_position()


func hand_tracking():
	var world_pos := get_viewport().get_canvas_transform().affine_inverse() * Udp.hand_screen_position
	global_position = global_position.lerp(world_pos, lerp_weight)


func grab_object():
	
	if is_holding: return
	
	var closest_distance = MAX_INT
	
	var objects = get_overlapping_bodies()
	
	for object in objects:
		if object.is_in_group("Objects"):
			var distance = object.global_position.distance_to(global_position)
			
			if distance < closest_distance: 
				closest_distance = distance
				closest_object = object
	
	if closest_object:
		is_holding = true
		if closest_object is MoveableObject:
			closest_object.activate(self,get_strength())
		if closest_object is StaticObject:
			closest_object.activate()
		var interactable = closest_object.get_node_or_null("InteractableComponent")
		if interactable:
			interactable.interact(self)

func get_strength():
	return get_parent().STRENGHT if get_parent() is Player else default_strength

func apply_input_mode():
	if is_active and mouse_mode and not get_tree().paused:
		Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func set_cursor_active(active: bool):
	is_active = active
	
	if not is_active:
		resetObject()
		change_color(Color.AQUA)
		first_time = true
	
	apply_input_mode()

func _on_mouse_mode_changed(new_mode: bool):
	mouse_mode = new_mode
	apply_input_mode()
