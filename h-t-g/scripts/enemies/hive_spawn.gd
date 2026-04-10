extends Node2D
class_name HiveSpawn

@onready var spawner: Spawner = $Spawner
@onready var spawn_timer: Timer = $SpawnTimer

@export var max_wasp_amount := 3
@export var min_timer := 2.0
@export var max_timer := 6.0
@export var wasp_population := 10


const WASP_PATH = preload("res://scenes/enemies/wasp.tscn")
var current_wasp_amount := 0
signal wasp_died

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	spawn_timer.start()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_spawn_timer_timeout() -> void:
	spawn_timer.wait_time = randf_range(min_timer, max_timer)
	
	if current_wasp_amount < max_wasp_amount && wasp_population > 0:
		current_wasp_amount += 1
		wasp_population -= 1
		var wasp = spawner.spawn(WASP_PATH, global_position)
		wasp.velocity = Vector2.ZERO
		wasp.died.connect(_on_wasp_dead)
		spawn_timer.start()
		print(global_position)
		print("Wasp ", wasp.global_position)
	

func _on_wasp_dead():
	current_wasp_amount -= 1
	wasp_died.emit()
	if spawn_timer.is_stopped():
		spawn_timer.start()
