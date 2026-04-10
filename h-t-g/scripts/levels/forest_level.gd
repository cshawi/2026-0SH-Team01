extends Node2D
class_name ForestLevelPart2

@onready var teleport_timer: Timer = $TeleportTimer
@onready var blue_letters: TileMapLayer = $BlueLetters
@onready var gate: TileMapLayer = $TileMapLayer4
@onready var hive_spawn: HiveSpawn = $HiveSpawn
@onready var hive_spawn_2: HiveSpawn = $HiveSpawn2


signal teleport(target: String)

var top_limit = 0
var grid_position := Vector2i(12, 4)
var atlas_position := Vector2i(8, 16)
var gate_position := Vector2i(24, 10)
var letters_source_id := 7
var dead_wasp_amount := 0
var door_length := 7

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hive_spawn.wasp_died.connect(on_wasp_dead)
	hive_spawn_2.wasp_died.connect(on_wasp_dead)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func open_gate():
	for i in range(door_length):
		gate.erase_cell(Vector2i(gate_position.x, gate_position.y + i))

func on_wasp_dead():
	dead_wasp_amount += 1
	
	if dead_wasp_amount % 2 == 0:
		blue_letters.set_cell(Vector2i(grid_position.x + (dead_wasp_amount / 2), grid_position.y), letters_source_id, Vector2i(atlas_position.x + (dead_wasp_amount / 2), atlas_position.y))
	
	if hive_spawn.wasp_population + hive_spawn_2.wasp_population == 0:
		open_gate()

func _on_portal_area_body_entered(body: Node2D) -> void:
	if body is Player:
		teleport_timer.start()


func _on_portal_area_body_exited(body: Node2D) -> void:
	if body is Player:
		teleport_timer.stop()

func _on_teleport_timer_timeout() -> void:
	teleport.emit("Part_1")
