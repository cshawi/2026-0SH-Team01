extends MoveableObject
class_name FullMotionObject

const LARGE_ROCK = "large_rock"

func set_weight() :
	if name.contains(LARGE_ROCK):
		var rand_weight = randf_range(300.00,500.00)
		weight = rand_weight
	pass
	
func set_object_scale():
	#maps l'aire du nouveau scale, comparer à la valeur dec sa ressource pour  mapper 
	#scale.x = 2
	#scale.y = 1.5 
	pass
	
