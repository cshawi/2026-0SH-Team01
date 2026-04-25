extends BaseEnemy
class_name Wasp

@onready var raycast = $RayCast
@onready var interactable_component: InteractableComponent = $InteractableComponent

@export_group("idle")
@export var wing_force := 3.0
@export var wall_distance := 30.0
@export var max_distance := 100.0
@export var max_wait_time := 2.5

@export_group("attack")
@export var attack_distance := 100.0
@export var attack_dash_speed := 100.0

var arrived_dist := 20
var hive = null

var attack_target := Vector2.ZERO

enum State {
	IDLE,
	WAIT,
	CHASE,
	ATTACK,
	DEAD
}

var current_state: State

var target : Vector2

func _ready():
	super()
	interactable_component.interacted.connect(die)
	change_state(State.IDLE)
	target = set_new_target()
	hitbox_component.hit.connect(_on_hit)
 
func _physics_process(delta):
	if current_state == State.DEAD:
		return
		
	if current_state != State.ATTACK:
		apply_wing_oscillation()
		move_and_slide()

	match current_state:
		State.IDLE:
			idle()
		State.CHASE:
			chase()
		State.ATTACK:
			attack()

func change_state(new_state: State):
	current_state = new_state
	
	match current_state:
		State.IDLE:
			animated_sprite.play("fly")
			hitbox_component.monitoring = false
		State.WAIT:
			velocity_component.direction = Vector2.ZERO
			await get_tree().create_timer(randf_range(0.5, max_wait_time)).timeout
			if current_state == State.WAIT:
				target = set_new_target()
				change_state(State.IDLE)
		State.CHASE:
			animated_sprite.play("fly")
			hitbox_component.set_deferred("monitoring", false)
		State.ATTACK:
			if player:
				animated_sprite.play("attack")
				attack_target = player.global_position
				hitbox_component.set_deferred("monitoring", true)
		State.DEAD:
			animated_sprite.play("die")
			velocity = Vector2.ZERO
			velocity_component.direction = Vector2.ZERO
			spawner.spawn(loot, global_position)
			await animated_sprite.animation_finished
			queue_free()

func idle():
	var dir_to_target = global_position.direction_to(target)
	var arrived = global_position.distance_to(target) < arrived_dist
	
	raycast.target_position = dir_to_target * wall_distance
	raycast.force_raycast_update()
	var wall_ahead = raycast.is_colliding()
	
	if arrived or wall_ahead:
		#target = set_new_target()
		#velocity_component.direction = Vector2.ZERO
		change_state(State.WAIT)
	else:
		goTo(dir_to_target)
		
func chase():
	if not player: return
	
	var margin := 20.0
	
	var dist = global_position.distance_to(player.global_position)
	var dir = global_position.direction_to(player.global_position)
	
	if dist > attack_distance + margin:
		goTo(dir)
	elif dist < attack_distance - margin:
		goTo(-dir)
	else:
		velocity_component.direction = Vector2.ZERO
		change_state(State.ATTACK)
	
func attack():
	if not attack_target:
		return
	var dist = global_position.distance_to(attack_target)
	var dir = global_position.direction_to(attack_target)
	
	if get_real_velocity().length() < 5.0:
		change_state(State.CHASE)
	
	if dist < 20:
		change_state(State.CHASE)
	else:
		velocity = dir * attack_dash_speed
		move_and_slide()

func goTo(dir : Vector2):
	velocity_component.direction = dir
	if player:
		var dir_player = global_position.direction_to(player.global_position)
		if dir_player.x != 0:
			var s = abs(scale.x) if dir_player.x < 0 else -abs(scale.x)
			animated_sprite.scale.x = s
			hitbox_component.scale.x = s
	elif dir.x != 0:
		var s = abs(scale.x) if dir.x < 0 else -abs(scale.x)
		animated_sprite.scale.x = s
		hitbox_component.scale.x = s
	
func set_new_target():
	var new_target = Vector2(global_position.x + randf_range(-max_distance, max_distance), global_position.y + randf_range(-max_distance, max_distance))
	return new_target

func apply_wing_oscillation():
	if animated_sprite.animation != "fly":
		return

	var frames = animated_sprite.sprite_frames
	var frame_count = frames.get_frame_count("fly")
	
	var progress = (animated_sprite.frame + animated_sprite.frame_progress) / frame_count
	
	var oscillation = cos(progress * TAU) * wing_force
	velocity.y += oscillation

func die(_cursor):
	died.emit()
	change_state(State.DEAD)
	
func desactivate():
	pass

func on_player_detected():
	if current_state != State.DEAD:
		change_state(State.CHASE)
		
func on_player_lost():
	if current_state != State.DEAD:
		change_state(State.IDLE)

func _on_hit(_hurtbox, _amount):
	change_state(State.CHASE)
