extends CharacterBody2D
class_name Player

@export var spell_scene: PackedScene

@onready var player_animation: AnimatedSprite2D = $PlayerAnimation
@onready var muzzle: Marker2D = $Muzzle
@onready var attack_range_shape: CollisionShape2D = $AttackRange/AttackRangeShape
@onready var attack_range = attack_range_shape.shape.radius
@onready var attack_range_area: Area2D = $AttackRange

const SPEED = 100
const JUMP_FORCE = -350
const GRAVITY = 900
const STRENGHT = 100 


var muzzle_offset: Vector2
var enemies_in_range: Array[Node2D] = []
var damage: float
var is_attacking := false
var is_casting := false
var was_casting := false
var spell: Area2D
var attack_animation: AnimatedSprite2D


func _ready() -> void:
	muzzle_offset = muzzle.position


func _physics_process(delta):
	is_casting = Input.is_action_pressed("Cast")

	# gravité
	if not is_on_floor():
		velocity.y += GRAVITY * delta
	
	# mouvement horizontal
	var direction = Input.get_axis("Left", "Right")
	velocity.x = direction * SPEED
	
	# flip
	if direction < 0:
		player_animation.flip_h = true
	elif direction > 0:
		player_animation.flip_h = false

	# jump
	if Input.is_action_just_pressed("Jump") and is_on_floor():
		velocity.y = JUMP_FORCE

	# attaques
	if not is_casting and not is_attacking:
		if Input.is_action_just_pressed("Attack_1"):
			print("attaque 1")
			is_attacking = true
			player_animation.play("attack_1")

		elif Input.is_action_just_pressed("Attack_2"):
			print("attaque 2")
			is_attacking = true
			player_animation.play("attack_2")

	# cast : jouer seulement au moment où on commence
	if is_casting and not was_casting and not is_attacking:
		print("Lévitation !!!")
		player_animation.play("casting_start")

	# animations normales
	if not is_attacking and not is_casting:
		if velocity.y != 0:
			if player_animation.animation != "jump":
				player_animation.play("jump")
		elif velocity.x != 0:
			if player_animation.animation != "walk":
				player_animation.play("walk")
		else:
			if player_animation.animation != "idle":
				player_animation.play("idle")

	was_casting = is_casting
	
	update_muzzle()
	
	move_and_slide()


func _on_player_animation_animation_finished() -> void:
	print(player_animation.animation)

	if player_animation.animation != "attack_1" and player_animation.animation != "attack_2" and player_animation.animation != "casting_start":
		return
	
	if player_animation.animation == "attack_1" or player_animation.animation == "attack_2":
		shoot()
		is_attacking = false
	elif player_animation.animation == "casting_start":
		if is_casting:
			player_animation.play("casting_levitation")
		else:
			player_animation.play("idle")

func get_closest_enemy():
	var enemies = get_tree().get_nodes_in_group("enemies")
	var closest_enemy = null
	var shortest_distance = attack_range

	for enemy in enemies:
		if enemy == null:
			continue
		if not is_instance_valid(enemy) or enemy.is_queued_for_deletion():
			continue

		var distance = attack_range_area.global_position.distance_to(enemy.global_position)
		if distance <= shortest_distance:
			shortest_distance = distance
			closest_enemy = enemy

	return closest_enemy

func shoot() -> void:
	var target = get_closest_enemy()

	spell = spell_scene.instantiate()
	spell.global_position = muzzle.global_position

	if target != null:
		spell.look_at(target.global_position)
	else:
		spell.global_rotation = muzzle.global_rotation

	if spell.has_method("setup"):
		spell.setup(SPEED * 2, damage, attack_range)

	get_tree().current_scene.add_child(spell)

	attack_animation = spell.get_node("AttackAnimation")
	if player_animation.animation == "attack_1":
		attack_animation.play("charge_1_start")
	else:
		attack_animation.play("charge_2")
		
func update_muzzle() -> void:
	if player_animation.flip_h:
		muzzle.position.x = -abs(muzzle_offset.x)
		muzzle.rotation = PI
	else:
		muzzle.position.x = abs(muzzle_offset.x)
		muzzle.rotation = 0.0

func _on_attack_range_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemies"):
		enemies_in_range.append(body)


func _on_attack_range_body_exited(body: Node2D) -> void:
	if body.is_in_group("enemies"):
		enemies_in_range.erase(body)
