extends StaticBody2D
class_name LimitWall

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func add_wall(x_position: int):
	var collision_shape = CollisionShape2D.new()
	var segment = SegmentShape2D.new()
	
	segment.a = Vector2(x_position, 0)
	segment.b = Vector2(x_position, 360)
	
	collision_shape.shape = segment
	add_child(collision_shape)
