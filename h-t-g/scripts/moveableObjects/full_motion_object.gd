extends MoveableObject
class_name FullMotionObject

const LARGE_ROCK = "large_rock"

func set_weight() :
	if name.contains(LARGE_ROCK):
		var rand_weight = randf_range(300.00,500.00)
		weight = rand_weight
	pass
	
func set_object_scale(object_mass: float):
	return pow(object_mass / 50.0, 0.35)
	
	
func apply_config():
	super()
	var s = set_object_scale(mass)
	scale = Vector2.ONE * s
	$Sprite2D.scale = Vector2.ONE * s
	$CollisionPolygon2D.scale = Vector2.ONE * s
	print("apply_config body scale = ", scale)
	print("apply_config sprite scale = ", $Sprite2D.scale)
