extends Area2D

@export var detected_object : BaseObject

var in_contact := false
var amount := 0

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Objects") and body.config == detected_object:
		amount += 1
		adjust_state()

func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("Objects") and body.config == detected_object:
		amount -= 1
		adjust_state()

func adjust_state():
	in_contact = amount > 0

func set_size(size : Vector2):
	$CollisionShape2D.size = size
