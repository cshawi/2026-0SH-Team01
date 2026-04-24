extends Area2D
class_name FlotationZone

@export var water_density := 1.0

const GRAVITY = 980

func _physics_process(_delta: float) -> void:
	var bodies = get_overlapping_bodies()
	
	for body in bodies:
		if body is RigidBody2D:
			var obj_density = body.density
			
			var buoyancy_factor = water_density / obj_density
			
			var buoyancy_force = Vector2.UP * GRAVITY * body.mass * buoyancy_factor
			
			body.apply_central_force(buoyancy_force)
