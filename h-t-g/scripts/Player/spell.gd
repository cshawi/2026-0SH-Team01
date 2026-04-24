extends Area2D
class_name Spell

@onready var attack_animation: AnimatedSprite2D = $AttackAnimation


var speed: float
var damage: float
var attack_range: float
var travelled_distance: float = 0.0

func setup(p_speed, p_damage, p_range):
	speed = p_speed
	damage = p_damage
	attack_range = p_range
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func _physics_process(delta: float) -> void:
	var distance = speed * delta
	position += transform.x * distance
	travelled_distance += distance
	if travelled_distance >= attack_range:
		speed = 0
		attack_animation.play("charge_1_end")
		await attack_animation.animation_finished
		call_deferred("destroy")
		
func _on_body_entered(body) -> void:
	if body.has_method("take_damage"):
		body.take_damage(damage)
		attack_animation.play("charge_1_end")
		await attack_animation.animation_finished
		call_deferred("destroy")



func destroy():
	queue_free()
	
