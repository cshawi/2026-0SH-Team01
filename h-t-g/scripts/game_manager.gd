extends Node2D
class_name GameManager


@export var world_map := "res://scenes/world_map.tscn"

var mouse_mode := true #temporaire le temps d'avoir les paramètres
var player_hp: float
var magic_cursor: MagicCursor

signal mouse_mode_changed

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
@warning_ignore("unused_parameter")
func _process(delta: float) -> void:
	pass

func register_level(level: Node) -> void:
	if level.has_signal("level_finished") and not level.level_finished.is_connected(on_level_finished):
		level.level_finished.connect(on_level_finished)
	if level.has_player:
		Hud.set_player_connection(level.player.get_node("HealthComponent"))
		Hud.show_player_control()

func set_mouse_mode(new_mode: bool):
	mouse_mode = new_mode
	mouse_mode_changed.emit(new_mode)

func on_level_finished(): #reçoit player.current_hp en paramètre
	await Fade_transition.play_transition(GameMaster.change_to_level, world_map)
	
func change_to_level(path: String) -> void: #passe de la carte du monde au niveau choisi
	get_tree().change_scene_to_file(path)
	await get_tree().process_frame
