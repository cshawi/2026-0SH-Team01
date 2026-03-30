extends Node2D
class_name ForestLevelPart1

@onready var teleport_timer: Timer = $TeleportTimer

signal teleport(target: String)

var top_limit = -530

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_portal_area_body_entered(body: Node2D) -> void:
	teleport_timer.start()

func _on_portal_area_body_exited(body: Node2D) -> void:
	teleport_timer.stop()

func _on_teleport_timer_timeout() -> void:
	teleport.emit("Part_2")
