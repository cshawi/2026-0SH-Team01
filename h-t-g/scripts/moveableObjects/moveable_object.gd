@tool
extends RigidBody2D
class_name MoveableObject

@export var config: MoveableConfig

#("Information")
var texture: Texture2D;
var collision_shape: Shape2D;
var weight: float;

#("Physique")
var vitess: float
var friction: float
var bounce: float
var push_force_required: float
var max_velocity: float
var can_rotate: bool = false
var is_static_until_pushed: bool = false

 #Interaction
var is_selected: bool = false
var is_destructible: bool
var durability: int
var damage_on_impact: int

#("Feedback")
var move_sound: AudioStream
var impact_sound: AudioStream
var break_sound: AudioStream
var spawn_particles_on_impact: bool = false

#("State")
var is_grounded: bool
var last_pusher: Node
var current_velocity: Vector2

func _ready():
	apply_config()

func _process(delta: float) -> void:
	#if(is_selected):
	action();
	pass
	
func action():
	pass

func apply_config():
	if config == null:
		push_warning("MoveableObject: config manquante")
		return
	name = config.name
	weight = config.weight
	$CollisionPolygon2D.polygon = config.collision_polygon
	$Sprite2D.texture = config.texture
	vitess = config.vitess
	friction = config.friction
	bounce = config.bounce
	push_force_required = config.push_force_required
	max_velocity = config.max_velocity
	gravity_scale = config.gravity_scale
	can_rotate = config.can_rotate
	is_static_until_pushed = config.is_static_until_pushed

	is_destructible = config.is_destructible
	durability = config.durability
	damage_on_impact = config.damage_on_impact

	move_sound = config.move_sound
	impact_sound = config.impact_sound
	break_sound = config.break_sound
	spawn_particles_on_impact = config.spawn_particles_on_impact
