extends MoveableObject
class_name FullMotionObject

const LARGE_ROCK = "large_rock"

func _ready():
	super()
	if not body_entered.is_connected(_on_body_entered):
		body_entered.connect(_on_body_entered)

#func set_weight() :
	#if name.contains(LARGE_ROCK):
		#var rand_weight = randf_range(300.00,500.00)
		#weight = rand_weight
	#pass

func action(delta: float):
	var distance = magic_cursor.global_position - global_position
	
	if distance.length() > max_distance:
		desactivate()
		return
	
	linear_velocity = distance * player_strength / mass

func _on_body_entered(body):
	if body.name == "Player":
		_on_touch_player()
		
func _on_touch_player():
	desactivate()
	linear_velocity = Vector2.ZERO
	apply_impulse(Vector2.DOWN * 200)
