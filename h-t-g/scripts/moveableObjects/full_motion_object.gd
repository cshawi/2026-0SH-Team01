extends MoveableObject
class_name FullMotionObject

const LARGE_ROCK = "large_rock"

#func set_weight() :
	#if name.contains(LARGE_ROCK):
		#var rand_weight = randf_range(300.00,500.00)
		#weight = rand_weight
	#pass
	#
func action(delta: float):
	var distance = magic_cursor.global_position - global_position
	
	if distance.length() > max_distance:
		desactivate()
		return
	
	linear_velocity = distance * player_strength/mass
