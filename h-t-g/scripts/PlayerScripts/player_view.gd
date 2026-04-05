extends Camera2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	zoom = zoom / get_parent().scale
	var map_limit = get_tree().current_scene.find_child("LimitWall")
	
	if map_limit:
		print(map_limit)
		print(map_limit.get_children())
		#limit_left = map_limit.get_child(0).shape.a.x
		#limit_right = map_limit.get_child(1).shape.a.x


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
