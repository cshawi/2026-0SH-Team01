extends Node2D


@onready var limit_wall: LimitWall = $LimitWall
@onready var player_spawn_point: Marker2D = $PlayerSpawnPoint
@onready var spawner: Spawner = $Spawner
@onready var forest_level_part_1: ForestLevelPart1 = $ForestLevelPart1
@onready var forest_level_part_2: ForestLevelPart2 = $ForestLevelPart2


@onready var player_path := preload("res://scenes/Player_scenes/player.tscn")
var player: Player
var player_view: Camera2D

var temp_next_level := "res://scenes/Levels Scenes/snow__scenes/snow_level.tscn"

signal level_finished() #mettre ne paramètre player.current_hp

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameMaster.register_level(self)
	limit_wall.add_wall(0)
	limit_wall.add_wall(640)
	
	player = spawner.spawn(player_path, player_spawn_point.global_position)
	player_view = player.get_node("PlayerView")
	player.get_node("MagicCursor").mouse_mode = GameMaster.mouse_mode
	player_view.limit_left = limit_wall.get_child(0).shape.a.x
	player_view.limit_right = limit_wall.get_child(1).shape.a.x
	
	forest_level_part_1.teleport.connect(on_teleport) #PAS de changement de scène, process_mode disabled voir Doc
	forest_level_part_2.teleport.connect(on_teleport) #est-ce qu'on veut recommencer les guêpes si on quitte???
	set_active_part(forest_level_part_1)
	
	
	
	print("Forest ready")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func set_active_part(active_part: Node):
	for part in [forest_level_part_1, forest_level_part_2]:
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

	# TileMapLayer
	if node.has_method("set_collision_enabled"):
		node.call_deferred("set_collision_enabled", enabled)

	#Recursion sur les enfants
	for child in node.get_children():
		set_collisions_enabled(child, enabled)

func spawn_player_at(marker: Marker2D) -> void:
	player.global_position = marker.global_position

func go_to_part_2() -> void:
	set_active_part(forest_level_part_2)
	spawn_player_at(forest_level_part_2.get_node("PlayerSpawnPoint2"))

func go_to_part_1() -> void:
	set_active_part(forest_level_part_1)
	spawn_player_at(forest_level_part_1.get_node("PlayerSpawnPoint1")) #pour le spawn du joueur, aller le chercher depuis la scène visible
	
func respawn(body: Node2D):
	body.global_position = player_spawn_point.global_position

func on_teleport(target: String):
	match target:
		"Part_1":
			await Fade_transition.play_transition(go_to_part_1)
		"Part_2":
			await Fade_transition.play_transition(go_to_part_2)
			

func _on_death_zone_body_entered(body: Node2D) -> void:
	if body is Player:
		await Fade_transition.play_transition(respawn, body)


func _on_end_level_area_body_entered(body: Node2D) -> void:
	if body is Player:
		await get_tree().create_timer(1).timeout
		await Fade_transition.play_transition(GameMaster.change_to_level, temp_next_level)
		#level_finished.emit() #ajouter player.current_hp
