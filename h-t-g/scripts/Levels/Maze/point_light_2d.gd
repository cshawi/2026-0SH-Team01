extends PointLight2D

@onready var magic_cursor: MagicCursor = $"../MagicCursor"

var nav_map: RID

func _process(_delta):
	if not nav_map.is_valid():
		return

	var mouse := magic_cursor.global_position

	var closest := NavigationServer2D.map_get_closest_point(
		nav_map,
		mouse
	)

	global_position = closest

func set_navigation_map(new_map: RID) -> void:
	nav_map = new_map
