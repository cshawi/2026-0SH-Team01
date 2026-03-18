extends CharacterBody2D
class_name MoveableObject

@export var config: MoveableConfig

var gravity: int 

var texture: Texture2D
var collision_shape: Shape2D
var weight: float

var magic_cursor: MagicCursor
var player_strength

func _ready():
	apply_config()
	
func _process(delta: float) -> void:
	pass
		
func _physics_process(delta: float) -> void:
	if magic_cursor:
		action(delta)
	else:
		physics_gravity(delta)
		
func physics_gravity(delta):
	if not is_on_floor():
		velocity.y += gravity * delta
	else:
		velocity.x = move_toward(velocity.x, 0, 15)
	move_and_slide()
	
func activate(cursor: MagicCursor, strength):
	magic_cursor = cursor
	player_strength = strength
	
func desactivate():
	magic_cursor = null
	
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
	gravity = params.gravity
	name = params.name
	weight = params.weight
	$CollisionPolygon2D.polygon = params.collision_polygon
	$Sprite2D.texture = params.texture
	velocity = Vector2.ZERO
	 
