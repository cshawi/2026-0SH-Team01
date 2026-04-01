extends Node2D
class_name GameManager

@onready var fade_transition: FadeTransition = $FadeTransition

var mouse_mode := true #temporaire le temps d'avoir les paramètres
var player_hp: float
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func register_level(level: Node) -> void:
	if level.has_signal("level_finished") and not level.level_finished.is_connected(on_level_finished):
		level.level_finished.connect(on_level_finished)


func on_level_finished(): #reçoit player.current_hp en paramètre
	pass #quand il termine un niveau on le ramène à la carte du monde
	
func change_to_level(path: String) -> void: #passe de la carte du monde au niveau choisi
	get_tree().change_scene_to_file(path)
	await get_tree().process_frame
	#temporairement applqué pour la suite logique des niveaux le temps qu'on fasse la carte du monde
