extends Control
class_name WorldMapPreview

@onready var texture_rect: TextureRect
@onready var level_done: TextureRect = $Background/LevelDone

func _ready() -> void:
	level_done.hide()

func show_done():
	level_done.show()

func hide_done():
	level_done.hide()
