extends Node2D
class_name World_Tomy

@onready var limit_wall: LimitWall = $LimitWall
@onready var player_view: Camera2D = $Player/PlayerView

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	limit_wall.add_wall(0)
	limit_wall.add_wall(1280)
	player_view.limit_left = limit_wall.get_child(0).shape.a.x
	player_view.limit_right = limit_wall.get_child(1).shape.a.x
	print("World ready")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
