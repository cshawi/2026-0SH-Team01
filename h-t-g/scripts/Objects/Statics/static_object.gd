extends StaticBody2D
class_name StaticObject

@export var config: StaticObjectConfig

@onready var interactable_component: InteractableComponent = $InteractableComponent

var textures: Array[Texture2D]
var weight: float = 0.0

func _ready():
	apply_config()
	interactable_component.interacted.connect(_on_interacted)
	
func action():
	pass

func apply_config():
	if config == null:
		push_warning("StaticObject: config manquante")
		return
	name = config.name
	$CollisionPolygon2D.polygon = config.collision_polygon
	textures = config.textures
	
	
func _on_interacted(cursor):
	action()
