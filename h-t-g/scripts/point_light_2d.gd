extends PointLight2D

@onready var nav_map = get_world_2d().navigation_map
@onready var magic_cursor: MagicCursor = $"../MagicCursor"

func _process(_delta):

	var mouse = magic_cursor.global_position

	var closest = NavigationServer2D.map_get_closest_point(
		nav_map,
		mouse
	)

	global_position = closest
