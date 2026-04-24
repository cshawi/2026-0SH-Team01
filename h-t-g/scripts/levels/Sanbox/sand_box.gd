extends Node2D


var has_player = false;


func _ready() -> void:
	GameMaster.register_level(self)
