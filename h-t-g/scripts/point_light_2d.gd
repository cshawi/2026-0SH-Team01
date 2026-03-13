extends PointLight2D

@onready var nav_map = get_world_2d().navigation_map

func _process(_delta):

	var mouse = get_global_mouse_position()

	var closest = NavigationServer2D.map_get_closest_point(
		nav_map,
		mouse
	)

	global_position = closest
