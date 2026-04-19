extends Control
class_name WorldMapPreview

@onready var texture_rect: TextureRect

func show_preview(texture: Texture2D):
	texture_rect.texture = texture
	show()

func hide_preview():
	hide()
