extends Node2D
class_name WolrdMap


@export var ship_scene: PackedScene
var has_player := false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameMaster.register_level(self)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_texture_button_pressed() -> void:
	await Fade_transition.play_transition(GameMaster.change_to_level, ship_scene)
