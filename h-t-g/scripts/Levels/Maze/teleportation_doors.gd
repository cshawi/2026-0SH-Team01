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
var is_teleporting := false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	area.body_entered.connect(_on_area_2d_body_entered.bind(door))
	area2.body_entered.connect(_on_area_2d_body_entered.bind(door_2))
	area.body_exited.connect(_on_area_2d_body_exited.bind(door))
	area2.body_exited.connect(_on_area_2d_body_exited.bind(door_2))
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta: float) -> void:
	_check_overlap_and_start_tp(area, door)
	_check_overlap_and_start_tp(area2, door_2)

func get_other_door():
	return door if current_door != door else door_2

func teleport_player():
	is_teleporting = true

	player.global_position = get_other_door().global_position
	current_door.action()
	get_other_door().action()

func _check_overlap_and_start_tp(check_area: Area2D, parent: OpenableObject) -> void:
	if not parent.is_open:
		return
	
	if is_teleporting:
		return

	var bodies := check_area.get_overlapping_bodies()
	for body in bodies:
		if body is Player:
			player = body
			current_door = parent

			if teleport_timer.is_stopped() and can_tp:
				teleport_timer.start()
			return

func _on_area_2d_body_entered(body: Node2D, parent: OpenableObject) -> void:
	if parent.is_open:
		teleport_timer.start()
		
	player = body
	current_door = parent

func _on_area_2d_body_exited(body: Node2D, parent: OpenableObject) -> void:
	if body is not Player:
		return

	if is_teleporting:
		return

	if parent.is_open:
		current_door.action()

	teleport_timer.stop()
	can_tp = true

func _on_teleport_timer_timeout() -> void:
	if not can_tp:
		return
	
	can_tp = false
	is_teleporting = true
	
	await Fade_transition.play_transition(teleport_player)
	
	await get_tree().physics_frame
	
	is_teleporting = false
		
		
