extends Node2D


@onready var limit_wall: LimitWall = $LimitWall
@onready var player_view: Camera2D = $Player/PlayerView
@onready var player_spawn_point: Marker2D = $PlayerSpawnPoint
@onready var spawner: Spawner = $Spawner

const PLAYER_PATH := preload("uid://cxfmddpxdyk6e")
var player: Player

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	limit_wall.add_wall(0)
	limit_wall.add_wall(640)
	player_view.limit_left = limit_wall.get_child(0).shape.a.x
	player_view.limit_right = limit_wall.get_child(1).shape.a.x
	print("Forest ready")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_death_zone_body_entered(body: Node2D) -> void:
	if body is Player:
		body.global_position = player_spawn_point.global_position
