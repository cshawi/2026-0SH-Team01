extends Resource;
class_name BaseObject

@export_group("Information")
@export var name: String;
@export var texture: Texture2D;
@export var collision_polygon: PackedVector2Array
@export_file("*.tscn") var target_scene: String = "res://scenes/Objects/Moveables/full_motion_object.tscn"
