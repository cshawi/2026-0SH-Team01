extends RigidBody2D
class_name MoveableObject

@export var config: MoveableConfig

@onready var interactable_component: InteractableComponent = $InteractableComponent

var texture: Texture2D
var collision_shape: Shape2D
var weight: float
var magic_cursor: MagicCursor
var player_strength
var max_distance = 100.0
var density := 1.0

func _ready():
	apply_config()
	contact_monitor = true
	max_contacts_reported = 4
	interactable_component.interacted.connect(_on_interacted)
	interactable_component.released.connect(desactivate)

		
func _physics_process(delta: float) -> void:
	if magic_cursor:
		action(delta)

func activate(cursor, strength):
	magic_cursor = cursor
	player_strength = strength

func desactivate():
	magic_cursor = null
	sleeping = false

func action(delta):
	pass
	
func _on_interacted(cursor):
	activate(cursor, cursor.get_strength())

func apply_config():
	if config == null:
		push_warning("MoveableObject: config manquante")
		return
	var params = config.duplicate()
	gravity_scale = params.gravity_scale
	name = params.name
	mass = params.weight
	density = params.density
	$CollisionPolygon2D.polygon = params.collision_polygon
	$Sprite2D.texture = params.texture
