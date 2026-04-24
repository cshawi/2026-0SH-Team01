extends Node2D

@onready var limit_wall: LimitWall = $LimitWall
@onready var player: Player = $Player

var has_player = false;
var top_limit := 0
var player_view: Camera2D

func _ready() -> void:
	limit_wall.add_wall(0)
	limit_wall.add_wall(640)
	
	player_view = player.get_node("PlayerView")
	player_view.limit_left = limit_wall.get_child(0).shape.a.x
	player_view.limit_right = limit_wall.get_child(1).shape.a.x
	player_view.limit_top = top_limit
	
	Hud.hide_all_menu()
	GameMaster.register_level(self)
