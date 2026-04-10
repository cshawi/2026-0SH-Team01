extends MoveableObject
class_name HorizontalMotionObject

@export var limit_left: float = -100.0
@export var limit_right: float = 100.0
@export var is_absolute: bool = false

var start_x: float
var actual_min_x: float
var actual_max_x: float

func _ready():
	super()
	start_x = global_position.x
	lock_rotation = true
	gravity_scale = 0

	if is_absolute:
		actual_min_x = limit_left
		actual_max_x = limit_right
	else:
		actual_min_x = start_x + limit_left
		actual_max_x = start_x + limit_right

func _physics_process(delta: float) -> void:
	linear_velocity.y = 0
	if magic_cursor:
		action(delta)
	else:
		linear_velocity.x = 0

func action(delta: float):
	var distance = magic_cursor.global_position.x - global_position.x
	
	if abs(distance) > max_distance:
		desactivate()
		return
		
	if global_position.x <= actual_min_x and distance < 0:
		linear_velocity.x = 0
		global_position.x = actual_min_x
		return
		
	if global_position.x >= actual_max_x and distance > 0:
		linear_velocity.x = 0
		global_position.x = actual_max_x
		return
	
	linear_velocity.x = distance * player_strength / mass
