extends Node2D
class_name Corpse

@export var max_distance := 150.0
@export var player_strength := 10.0
@export var max_speed := 1200.0

@export var config: MoveableConfig

var current_grabbed_body: RigidBody2D = null
var magic_cursor: MagicCursor

const PLAYER_LAYER := 2

func _ready():
	# On boucle sur tous les membres pour configurer l'interaction
	for child in get_children():
		if child is RigidBody2D:
			_setup_member(child)

func _setup_member(member: RigidBody2D):
	member.contact_monitor = true
	member.max_contacts_reported = 4

	if not member.body_entered.is_connected(_on_member_body_entered):
		member.body_entered.connect(_on_member_body_entered.bind(member))

	var component = member.find_child("InteractableComponent")
	if component:
		component.interacted.connect(_on_member_interacted.bind(member))
		component.released.connect(desactivate)
	else:
		push_warning("Le membre " + member.name + " n'a pas d'InteractableComponent")



func _physics_process(delta: float) -> void:
	if magic_cursor and current_grabbed_body:
		action(delta)

func _on_member_interacted(cursor: MagicCursor, member: RigidBody2D):
	magic_cursor = cursor
	player_strength = cursor.get_strength()
	current_grabbed_body = member
	current_grabbed_body.sleeping = false

func _on_member_body_entered(body: Node, member: RigidBody2D) -> void:
	if body is Player:
		_on_touch_player()

func _on_touch_player() -> void:
	desactivate()
	calm_all_members()
	ignore_player_for_all_members(0.1)

func calm_all_members() -> void:
	for child in get_children():
		if child is RigidBody2D:
			child.linear_velocity = child.linear_velocity.limit_length(80)
			child.angular_velocity = 0.0
			child.sleeping = false

func ignore_member_player_temporarily(member: RigidBody2D, duration: float) -> void:
	if not is_instance_valid(member):
		return

	member.collision_mask &= ~(1 << (PLAYER_LAYER - 1))

	await get_tree().create_timer(duration).timeout

	if is_instance_valid(member):
		member.collision_mask |= 1 << (PLAYER_LAYER - 1)


func ignore_player_for_all_members(duration: float) -> void:
	for child in get_children():
		if child is RigidBody2D:
			child.collision_mask &= ~(1 << (PLAYER_LAYER - 1))

	await get_tree().create_timer(duration).timeout

	for child in get_children():
		if child is RigidBody2D and is_instance_valid(child):
			child.collision_mask |= 1 << (PLAYER_LAYER - 1)



func desactivate():
	# On remet tout à null pour arrêter le mouvement dans _physics_process
	magic_cursor = null
	current_grabbed_body = null

func action(delta: float):
	if not current_grabbed_body or not magic_cursor:
		return

	var distance_vec = magic_cursor.global_position - current_grabbed_body.global_position

	# Sécurité de distance
	if distance_vec.length() > max_distance:
		desactivate()
		return

	# Sécurité de collision avec le joueur
	if should_block_control():
		desactivate()
		current_grabbed_body.linear_velocity = current_grabbed_body.linear_velocity.limit_length(80)
		return

	# Calcul et application de la physique
	var target_velocity = distance_vec * player_strength / current_grabbed_body.mass
	target_velocity = target_velocity.limit_length(max_speed)
	current_grabbed_body.linear_velocity = target_velocity

func should_block_control() -> bool:
	if not current_grabbed_body:
		return false

	for body in current_grabbed_body.get_colliding_bodies():
		if body is Player:
			ignore_member_player_temporarily(current_grabbed_body, 0.1)
			return true

	return false


func ignore_player_temporarily(duration: float) -> void:
	if not current_grabbed_body: return
	var body_to_ignore = current_grabbed_body
	body_to_ignore.collision_mask &= ~(1 << (PLAYER_LAYER - 1))
	await get_tree().create_timer(duration).timeout
	if is_instance_valid(body_to_ignore):
		body_to_ignore.collision_mask |= 1 << (PLAYER_LAYER - 1)
