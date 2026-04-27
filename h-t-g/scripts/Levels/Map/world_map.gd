extends Node2D
class_name WorldMap


var has_player := false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Hud.hide_all_menu()
	GameMaster.register_level(self)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
