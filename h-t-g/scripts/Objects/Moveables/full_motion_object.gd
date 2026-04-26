extends MoveableObject
class_name FullMotionObject

const LARGE_ROCK = "large_rock"


@export var max_speed := INF
@export var cast_length := 10.0

@onready var wall_cast: ShapeCast2D = $WallCast

func _ready():
	super()
	if not body_entered.is_connected(_on_body_entered):
		body_entered.connect(_on_body_entered)

func action(_delta: float):
	if should_block_control():
		desactivate()
		return
		
	var distance := magic_cursor.global_position - global_position

	if distance.length() > max_distance:
		desactivate()
		return

	var target_velocity = distance * player_strength / mass

	if target_velocity.length() > max_speed:
		target_velocity = target_velocity.normalized() * max_speed

	if wall_cast and target_velocity.length() > 0.0:
		var dir = target_velocity.normalized()
		var global_target = global_position + dir * cast_length
		var local_target := wall_cast.to_local(global_target)

		wall_cast.target_position = local_target
		wall_cast.force_shapecast_update()

		if wall_cast.is_colliding():
			var safe_fraction := wall_cast.get_closest_collision_safe_fraction()
			safe_fraction = max(0.0, safe_fraction - 0.05)
			target_velocity *= safe_fraction

			var normal = wall_cast.get_collision_normal(0)
			var dot = target_velocity.dot(normal)

			if dot < 0.0:
				target_velocity -= normal * dot

	linear_velocity = target_velocity

func _on_body_entered(body):
	if body is Player:
		_on_touch_player()

func _on_touch_player():
	desactivate()
	sleeping = false
	ignore_player_temporarily(0.1)
	
func should_block_control() -> bool:
	for body in get_colliding_bodies():
		if body is Player:
			return true

		if body is MoveableObject:
			for other_body in body.get_colliding_bodies():
				if other_body is Player:
					return true

	return false
