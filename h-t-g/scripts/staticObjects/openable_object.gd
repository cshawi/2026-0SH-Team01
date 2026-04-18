extends StaticObject
class_name OpenableObject

@export var is_open := false
@export var is_locked := false
@onready var collision_polygon_2d: CollisionPolygon2D = $Area2D/CollisionPolygon2D


func _ready():
	super()
	get_door()
	collision_polygon_2d.polygon = config.collision_polygon


func action():
	if not is_locked:
		is_open = !is_open
		get_door()
	

func get_door():
	if(is_open):
		$Sprite2D.texture = textures[1]
	else:
		$Sprite2D.texture = textures[0]

func _on_area_2d_body_entered(body: Node2D) -> void:
	pass # Replace with function body.
