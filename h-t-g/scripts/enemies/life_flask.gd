extends CharacterBody2D
class_name LifeFlask

var GRAVITY := 900.0

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y += GRAVITY * delta
	move_and_slide()

func _on_detection_area_body_entered(body: Node2D) -> void:
	body.health_component.heal(3 + randi() % 3)
	queue_free()
