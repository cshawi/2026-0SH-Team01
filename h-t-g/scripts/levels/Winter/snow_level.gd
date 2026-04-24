extends Node2D
class_name SnowLevel

@onready var player_spawn_point: Marker2D = $PlayerSpawnPoint
@onready var spawner: Spawner = $Spawner
@onready var limit_wall: LimitWall = $LimitWall
@onready var checkpoint: Checkpoint = $Checkpoint
@onready var checkpoint_2: Checkpoint = $Checkpoint2
@onready var checkpoint_3: Checkpoint = $Checkpoint3
@onready var checkpoint_4: Checkpoint = $Checkpoint4
@onready var checkpoint_5: Checkpoint = $Checkpoint5

@onready var death_zone: Area2D = $DeathZone
@onready var death_zone_2: Area2D = $DeathZone2
@onready var death_zone_3: Area2D = $DeathZone3


@onready var player_path := preload("res://scenes/Player/player.tscn")
var player: Player
var player_view: Camera2D
var has_player := true

var limit_top := -500
var limit_right := 2300
var limit_left := 0

var temp_next_level := "res://scenes/Levels Scenes/maze_key.tscn"

signal level_finished

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameMaster.register_level(self)
	limit_wall.add_wall(limit_left)
	limit_wall.add_wall(limit_right)
	
	player = spawner.spawn(player_path, player_spawn_point.global_position)
	player_view = player.get_node("PlayerView")
	player_view.limit_left = limit_wall.get_child(0).shape.a.x
	player_view.limit_right = limit_wall.get_child(1).shape.a.x
	player_view.limit_top = limit_top
	
	if not death_zone.is_connected("body_entered", _on_death_zone_body_entered):
		death_zone.body_entered.connect(_on_death_zone_body_entered)
	if not death_zone_2.is_connected("body_entered", _on_death_zone_body_entered):
		death_zone_2.body_entered.connect(_on_death_zone_body_entered)
	if not death_zone_3.is_connected("body_entered", _on_death_zone_body_entered):
		death_zone_3.body_entered.connect(_on_death_zone_body_entered)
	
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func spawn_player_at(marker: Marker2D) -> void:
	player.global_position = marker.global_position

func _on_death_zone_body_entered(body: Node2D) -> void:
	if body is Player:
		await Fade_transition.play_transition(spawn_player_at, player_spawn_point)


func _on_end_level_area_body_entered(body: Node2D) -> void:
	if body is Player:
		await get_tree().create_timer(1).timeout
		level_finished.emit() #ajouter player.current_hp


func _on_checkpoint_body_entered(body: Node2D) -> void:
	if body is Player:
		player_spawn_point.global_position = checkpoint.global_position


func _on_checkpoint_2_body_entered(body: Node2D) -> void:
	if body is Player:
		player_spawn_point.global_position = checkpoint_2.global_position
		
func _on_checkpoint_3_body_entered(body: Node2D) -> void:
	if body is Player:
		player_spawn_point.global_position = checkpoint_3.global_position
		
func _on_checkpoint_4_body_entered(body: Node2D) -> void:
	if body is Player:
		player_spawn_point.global_position = checkpoint_4.global_position
		
func _on_checkpoint_5_body_entered(body: Node2D) -> void:
	if body is Player:
		player_spawn_point.global_position = checkpoint_5.global_position
