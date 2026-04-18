extends Node2D
class_name TeleportationDoors


@onready var area: Area2D = $Door/Area2D
@onready var area2: Area2D = $Door2/Area2D
@onready var door: OpenableObject = $Door
@onready var door_2: OpenableObject = $Door2
@onready var teleport_timer: Timer = $TeleportTimer

var current_door: OpenableObject
var player: Player
var can_tp := true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	area.body_entered.connect(_on_area_2d_body_entered.bind(door))
	area2.body_entered.connect(_on_area_2d_body_entered.bind(door_2))
	area.body_exited.connect(_on_area_2d_body_exited)
	area2.body_exited.connect(_on_area_2d_body_exited)
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func get_other_door():
	return door if current_door != door else door_2

func teleport_player():
	player.global_position = get_other_door().global_position
	current_door.action()
	get_other_door().action()

func _on_area_2d_body_entered(body: Node2D, parent: OpenableObject) -> void:
	if parent.is_open:
		player = body
		current_door = parent
		teleport_timer.start()

func _on_area_2d_body_exited(body: Node2D) -> void:
	teleport_timer.stop()
	can_tp = true
	print("Je sors")

func _on_teleport_timer_timeout() -> void:
	if can_tp:
		print("can_tp")
		can_tp = false
		await Fade_transition.play_transition(teleport_player)
		
