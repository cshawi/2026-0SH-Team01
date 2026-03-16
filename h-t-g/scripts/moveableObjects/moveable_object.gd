@tool
extends CharacterBody2D
class_name MoveableObject

@export var config: MoveableConfig

const GRAVITY = 980

#("Information")
var texture: Texture2D
var collision_shape: Shape2D
var weight: float

#("Physique")
@export var speed:=200.0
@export var  damping:=0.0

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

var magic_cursor: MagicCursor
var player_strength
func _ready():
	apply_config()

func _process(delta: float) -> void:
	#if(magic_cursor):
		#action()
	pass
		
func _physics_process(delta: float) -> void:
	if magic_cursor:
		action(delta)
	else:
		gravity(delta)
		
func gravity(delta):
	if not is_on_floor():
		velocity.y += GRAVITY * delta
	else:
		velocity.x = move_toward(velocity.x, 0, 15)
		
	move_and_slide()
	
func activate(cursor: MagicCursor, strength):
	magic_cursor = cursor
	player_strength = strength
	
	print("Activate =>", magic_cursor )
	#comment assigner une postion en x et y pour un rigide body2d
	
func desactivate():
	magic_cursor = null
	print("Desactivat => " , magic_cursor)
	
func action(delta):
	var distance = (magic_cursor.global_position - global_position)
	if distance.length() > 150:
		desactivate()
		return
	
	velocity = distance * player_strength / weight
	var collision = move_and_collide(velocity * delta)
	if collision:
		velocity = Vector2.ZERO

func apply_config():
	if config == null:
		push_warning("MoveableObject: config manquante")
		return
	var params = config.duplicate()
	name = params.name
	weight = params.weight
	$CollisionPolygon2D.polygon = params.collision_polygon
	$Sprite2D.texture = params.texture
	#speed = config.vitess
	#friction = config.friction
	#bounce = config.bounce
	#push_force_required = config.push_force_required
	#max_velocity = config.max_velocity
	#can_rotate = config.can_rotate
	#is_static_until_pushed = config.is_static_until_pushed

	#is_destructible = config.is_destructible
	#durability = config.durability
	#damage_on_impact = config.damage_on_impact
#
	#move_sound = config.move_sound
	#impact_sound = config.impact_sound
	#break_sound = config.break_sound
	#spawn_particles_on_impact = config.spawn_particles_on_impact
