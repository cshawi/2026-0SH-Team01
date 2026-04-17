extends Node2D



signal level_finished
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameMaster.register_level(self)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_end_level_area_body_entered(body: Node2D) -> void:
	print(body)
	if body is FullMotionObject:
		await get_tree().create_timer(1).timeout
		get_tree().quit()
