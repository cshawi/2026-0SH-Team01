extends Node2D
class_name ShipManager

@onready var maze_doors: Node2D = $Maze_Doors
@onready var maze_key: Node2D = $Maze_Key
@onready var easy_maze_key: Node2D = $EasyMazeKey

var player: Player
var player_view: Camera2D
var has_player := false

signal level_finished
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player = maze_doors.player
	player_view = maze_doors.player_view
	
	maze_doors.teleport.connect(on_teleport)
	maze_key.teleport.connect(on_teleport)
	easy_maze_key.teleport.connect(on_teleport)
	maze_key.key_obtained.connect(on_key_obtained)
	easy_maze_key.key_obtained.connect(on_key_obtained)
	set_active_part(maze_doors)
	
	Hud.hide_all_menu()
	GameMaster.register_level(self)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func set_active_part(active_part: Node):
	for part in [maze_doors, maze_key, easy_maze_key]:
		var is_active = part == active_part
		part.visible = is_active
		
		if is_active:
			part.process_mode = Node.PROCESS_MODE_INHERIT
			
			if player_view:
				player_view.limit_top = part.top_limit
		else:
			part.process_mode = Node.PROCESS_MODE_DISABLED
		set_collisions_enabled(part, is_active)

func set_collisions_enabled(node: Node, enabled: bool) -> void:
	# CollisionShape2D / CollisionPolygon2D
	if node is CollisionShape2D or node is CollisionPolygon2D:
		node.set_deferred("disabled", not enabled)

	# Area2D
	if node is Area2D:
		node.set_deferred("monitoring", enabled)
		node.set_deferred("monitorable", enabled)
		
	# TileMapLayer
	if node.has_method("set_collision_enabled"):
		node.call_deferred("set_collision_enabled", enabled)

	#Recursion sur les enfants
	for child in node.get_children():
		set_collisions_enabled(child, enabled)

func disable_node_completely(node: Node) -> void:
	node.process_mode = Node.PROCESS_MODE_DISABLED
	
	if node is CanvasItem:
		node.visible = false
	
	set_collisions_enabled(node, false)

	for child in node.get_children():
		disable_node_completely(child)

func enable_node_completely(node: Node) -> void:
	node.process_mode = Node.PROCESS_MODE_INHERIT
	
	if node is CanvasItem:
		node.visible = true
	
	set_collisions_enabled(node, true)

	for child in node.get_children():
		enable_node_completely(child)

func spawn_player_at(marker: Marker2D) -> void:
	player.global_position = marker.global_position

func go_to_part_2(diff: String) -> void:
	disable_node_completely(player)
	
	if player_view:
		player_view.enabled = false
	
	set_active_part(maze_key) if diff == "Hard" else set_active_part(easy_maze_key)

func go_to_part_1() -> void:
	set_active_part(maze_doors)
	enable_node_completely(player)
	spawn_player_at(maze_doors.get_node("PlayerSpawnPoint"))
	
	if player_view:
		player_view.enabled = true
		player_view.make_current()

func on_teleport(target: String, diff: String):
	match target:
		"Part_1":
			await Fade_transition.play_transition(go_to_part_1)
		"Part_2":
			await Fade_transition.play_transition(go_to_part_2, diff)

func on_key_obtained():
	maze_doors.get_node("Doors/Door").is_locked = false
	maze_doors.get_node("Chest").is_locked = true
	maze_doors.get_node("Chest2").is_locked = true
