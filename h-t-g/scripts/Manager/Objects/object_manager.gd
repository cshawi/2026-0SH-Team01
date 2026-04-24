extends Node2D
class_name ObjectManager

@export var respawn_on_out_of_bounds: bool = true
@export var boundary_rect: Rect2 = Rect2(0, 0, 1000, 1000)

var managed_objects := []
var objects_positions := {}

func _ready():
	update_managed_objects()
	set_starting_positions()

func _physics_process(_delta):
	if respawn_on_out_of_bounds:
		_check_boundaries()

func _check_boundaries():
	for object in managed_objects:
		if not boundary_rect.has_point(object.global_position):
			respawn_object(object)

func set_starting_positions():
	for object in managed_objects:
		objects_positions[object] = object.global_position
		
func update_managed_objects():
	managed_objects = []
	for object in get_children():
		if object is MoveableObject:
			managed_objects.append(object)
			
func reset_all():
	for object in managed_objects:
		respawn_object(object)
			
func respawn_object(object: MoveableObject):
	object.global_position = objects_positions[object]
	object.global_rotation = 0
	if object is RigidBody2D:
		object.linear_velocity = Vector2.ZERO
		object.angular_velocity = 0
