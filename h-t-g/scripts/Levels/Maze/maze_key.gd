extends Node2D

@onready var magic_cursor: MagicCursor = $MagicCursor

var top_limit := 0

signal teleport(target: String, diff: String)
signal key_obtained

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	magic_cursor.hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_end_level_area_body_entered(body: Node2D) -> void:
	if body is FullMotionObject:
		await get_tree().create_timer(1).timeout
		key_obtained.emit()
		teleport.emit("Part_1", "")
