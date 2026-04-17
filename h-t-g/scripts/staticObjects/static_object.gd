extends Node2D
class_name StaticObject


@export var config: StaticObjectConfig

#@export_group("Interaction")
@export var is_click :bool = false;
var inerectable_amount := 0;

@onready var interactable_component: InteractableComponent = $InteractableComponent

var weight :float=0.0;
func _ready():
	apply_config()
	interactable_component.interacted.connect(_on_interacted)

func _process(delta: float) -> void:
	if(GameMaster.magic_cursor.is_grabing):
		action();
	pass
	
func action():
	pass
	#if(is_open):
		#$Sprite2D.texture = config.texture2
		#print("porte ouvert")
	#else:
		#$Sprite2D.texture = config.texture
		#print("porte fermer")
	#is_open = !is_open

func apply_config():
	if config == null:
		push_warning("StaticObject: config manquante")
		return
	name = config.name
	$CollisionPolygon2D.polygon = config.collision_polygon
	$Sprite2D.texture = config.texture
	is_click = config.is_click;
	#is_open = config.is_open;
	
func _on_interacted(cursor):
	action()
