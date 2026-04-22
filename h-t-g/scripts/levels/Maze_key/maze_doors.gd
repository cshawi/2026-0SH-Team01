extends Node2D
class_name MazeDoors

@onready var hint_area: Area2D = $HintArea
@onready var roll_player_help: RollPlayerHelp = $RollPlayerHelp
@onready var exit_door: OpenableObject = $Doors/Door
@onready var chest: OpenableObject = $Chest
@onready var chest_area : Area2D = chest.get_node("Area2D")
@onready var teleport_timer: Timer = $"TeleportTimer"

@onready var player_path := preload("res://scenes/Player_scenes/player.tscn")
@onready var limit_wall: LimitWall = $LimitWall
@onready var player_spawn_point: Marker2D = $PlayerSpawnPoint
@onready var player_spawn_point_2: Marker2D = $PlayerSpawnPoint2
@onready var spawner: Spawner = $Spawner

var player: Player
var player_view: Camera2D
var player_scale = 0.7
var top_limit := 0

signal teleport(target: String)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	chest_area.body_entered.connect(_on_chest_entered)
	chest_area.body_exited.connect(_on_chest_exited)
	limit_wall.add_wall(0)
	limit_wall.add_wall(640)
	
	player = spawner.spawn(player_path, player_spawn_point_2.global_position)
	player.scale *= player_scale
	player_view = player.get_node("PlayerView")
	player_view.limit_left = limit_wall.get_child(0).shape.a.x
	player_view.limit_right = limit_wall.get_child(1).shape.a.x


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_area_2d_body_entered(body: Node2D) -> void:
	if exit_door.is_open:
		await get_tree().create_timer(1.0).timeout
		get_parent().level_finished.emit()


func _on_hint_area_body_entered(body: Node2D) -> void:
	if exit_door.is_locked:
		hint_area.queue_free()
		roll_player_help.set_message("Cette porte est verrouillé, trouvez un moyen de l'ouvrir.")
		roll_player_help.show_message()

func _on_chest_entered(body: Node2D):
	if chest.is_open and not chest.is_locked:
		teleport_timer.start()
	
func _on_chest_exited(body: Node2D):
	if chest.is_open:
		teleport_timer.stop()
	


func _on_teleport_timer_timeout() -> void:
	teleport.emit("Part_2")
