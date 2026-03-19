extends RigidBody2D
class_name MoveableObject

@export var config: MoveableConfig


var texture: Texture2D
var collision_shape: Shape2D
var weight: float
var magic_cursor: MagicCursor
var player_strength
var max_distance = 150.0

func _ready():
	apply_config()
	contact_monitor = true
	max_contacts_reported = 4
	if not body_entered.is_connected(_on_body_entered):
		body_entered.connect(_on_body_entered)
		
func _physics_process(delta: float) -> void:
	if magic_cursor:
		action(delta)

func _on_body_entered(body):
	if body.name == "Player":
		on_touch_player(body)
		
func on_touch_player(player):
	desactivate()
	linear_velocity = Vector2.ZERO
	apply_impulse(Vector2.DOWN * 200)
	

func activate(cursor, strength):
	magic_cursor = cursor
	player_strength = strength

func desactivate():
	if magic_cursor:
		magic_cursor.resetObject()
	magic_cursor = null
	
func action(delta):
	var distance = magic_cursor.global_position - global_position
	
	if distance.length() > max_distance:
		desactivate()
		return
	
	linear_velocity = distance * player_strength/mass
	
func apply_config():
	if config == null:
		push_warning("MoveableObject: config manquante")
		return
	var params = config.duplicate()
	gravity_scale = params.gravity_scale
	name = params.name
	mass = params.weight
	$CollisionPolygon2D.polygon = params.collision_polygon
	$Sprite2D.texture = params.texture
