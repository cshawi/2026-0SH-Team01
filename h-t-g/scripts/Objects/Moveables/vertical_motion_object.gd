extends MoveableObject
class_name VerticalMotionObject

@export var limit_up: float = -100.0
@export var limit_down: float = 100.0
@export var is_absolute: bool = false
@export var can_fall: bool = true
@export var max_falling_speed: float = 980

var start_y: float
var actual_min_y: float
var actual_max_y: float

func _ready():
	super()
	start_y = global_position.y
	lock_rotation = true

	if is_absolute:
		actual_min_y = limit_up
		actual_max_y = limit_down
	else:
		actual_min_y = start_y + limit_up
		actual_max_y = start_y + limit_down

func _physics_process(delta: float) -> void:
	linear_velocity.x = 0
	
	if magic_cursor:
		action(delta)
	elif can_fall:
		if linear_velocity.y > max_falling_speed:
			linear_velocity.y = max_falling_speed
		
		if global_position.y >= actual_max_y:
			linear_velocity.y = 0
			global_position.y = actual_max_y
	else:
		linear_velocity.y = 0

func action(delta: float):
	var distance = magic_cursor.global_position.y - global_position.y
	
	if abs(distance) > max_distance:
		desactivate()
		return
		
	if global_position.y <= actual_min_y and distance < 0:
		linear_velocity.y = 0
		global_position.y = actual_min_y
		return
		
	if global_position.y >= actual_max_y and distance > 0:
		linear_velocity.y = 0
		global_position.y = actual_max_y
		return
	
	linear_velocity.y = distance * player_strength / mass
