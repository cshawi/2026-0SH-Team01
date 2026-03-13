extends Node2D
class_name StaticObject


@export var config: StaticObjectConfig

#@export_group("Interaction")
var is_click :bool = false;
var is_open :bool = false;
var weight :float=0.0;
func _ready():
	apply_config()

func _process(delta: float) -> void:
	if(is_click):
		action();
	pass
	
func action():
	pass

func apply_config():
	if config == null:
		push_warning("StaticObject: config manquante")
		return
	name = config.name
	$CollisionPolygon2D.polygon = config.collision_polygon
	$Sprite2D.texture = config.texture
	weight = config.weight
	is_click = config.is_click;
	is_open = config.is_open;
