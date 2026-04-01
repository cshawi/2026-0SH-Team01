extends Node2D
class_name ForestLevelPart2

@onready var teleport_timer: Timer = $TeleportTimer
@onready var blue_letters: TileMapLayer = $BlueLetters
@onready var gate: TileMapLayer = $TileMapLayer4

@onready var test_timer: Timer = $TestTimer

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
	for enemy in get_tree().get_nodes_in_group("enemies"):
		enemy.dead.connect(on_wasp_dead)
	on_wasp_dead()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func open_gate():
	for i in range(door_length):
		gate.erase_cell(Vector2i(gate_position.x, gate_position.y + i))

func on_wasp_dead():
	test_timer.start()
	dead_wasp_amount += 1
	if dead_wasp_amount <= 8:
		blue_letters.set_cell(Vector2i(grid_position.x + dead_wasp_amount, grid_position.y), letters_source_id, Vector2i(atlas_position.x + dead_wasp_amount, atlas_position.y))
	else:
		open_gate()
		test_timer.stop()
	

func _on_portal_area_body_entered(body: Node2D) -> void:
	teleport_timer.start()


func _on_portal_area_body_exited(body: Node2D) -> void:
	teleport_timer.stop()

func _on_teleport_timer_timeout() -> void:
	teleport.emit("Part_1")


func _on_test_timer_timeout() -> void:
	on_wasp_dead()
