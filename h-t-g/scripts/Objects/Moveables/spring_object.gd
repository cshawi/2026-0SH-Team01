extends MoveableObject
class_name SpringObject

@export var resistance := 1.0
@export var power := 5.0
@export var max_compression := 64.0

var max_height : float
var base_x : float

func _ready():
	super()
	max_height = global_position.y
	base_x = global_position.x
	lock_rotation = true
	gravity_scale = 0
	
func _physics_process(delta: float) -> void:
	linear_velocity.x = 0
	global_position.x = base_x
	
	if magic_cursor:
		action(delta)
	else:
		_return_to_rest(delta)
	
func action(delta):
	var distance = magic_cursor.global_position.y - global_position.y
	
	var current_compression = global_position.y - max_height
	
	if abs(distance) > max_distance:
		desactivate()
		return
		
	if global_position.y <= max_height and distance < 0:
		linear_velocity.y = 0
		global_position.y = max_height
		return
		
	if current_compression >= max_compression and distance > 0:
		linear_velocity.y = 0
		global_position.y = max_height + max_compression
		return
	if distance > 0:
		var spring_force = current_compression * resistance
		linear_velocity.y = distance - spring_force
	else:
		linear_velocity.y = distance
	
func _return_to_rest(_delta):
	var dist_to_rest = max_height - global_position.y
	
	if abs(dist_to_rest) < 0.5:
		global_position.y = max_height
		linear_velocity.y = 0
	else:
		linear_velocity.y = dist_to_rest * resistance * power
