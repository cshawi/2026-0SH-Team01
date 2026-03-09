extends StaticObject
class_name FullStaticObject

func action():
	if(is_open):
		$Sprite2D.texture = config.texture2
		print("porte ouvert")
	else:
		$Sprite2D.texture = config.texture
		print("porte fermer")
	pass
