extends Node2D

@onready var magic_cursor: MagicCursor = $MagicCursor
@onready var navigation_region: NavigationRegion2D = $NavigationRegion2D
@onready var point_light: PointLight2D = $PointLight2D

var navigation_map: RID
var top_limit := 0

signal teleport(target: String, diff: String)
signal key_obtained

func _ready() -> void:
	magic_cursor.hide()

	navigation_map = NavigationServer2D.map_create()
	NavigationServer2D.map_set_active(navigation_map, true)

	navigation_region.set_navigation_map(navigation_map)

	if point_light.has_method("set_navigation_map"):
		point_light.set_navigation_map(navigation_map)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_end_level_area_body_entered(body: Node2D) -> void:
	if body is FullMotionObject:
		await get_tree().create_timer(1).timeout
		key_obtained.emit()
		teleport.emit("Part_1", "")
