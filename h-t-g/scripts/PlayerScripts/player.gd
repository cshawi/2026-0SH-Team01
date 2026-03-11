extends CharacterBody2D
class_name Player

@export var spell_scene: PackedScene

@onready var player_animation: AnimatedSprite2D = $PlayerAnimation
@onready var muzzle: Marker2D = $Muzzle
@onready var attack_range_shape: CollisionShape2D = $AttackRange/AttackRangeShape
@onready var attack_range = attack_range_shape.shape.radius

const SPEED = 100
const JUMP_FORCE = -350
const GRAVITY = 900
var damage: float
var is_casting := false
var spell: Area2D
var attack_animation: AnimatedSprite2D


func _ready() -> void:
	pass

func _physics_process(delta):
	#is_casting = Input.is_action_pressed("Cast")
	# gravité
	if not is_on_floor():
		velocity.y += GRAVITY * delta
	
	# mouvement horizontal
	var direction = Input.get_axis("Left", "Right")
	velocity.x = direction * SPEED
	
	if not is_casting:
		if velocity.x == 0 && velocity.y == 0:
			player_animation.play("idle")
		elif velocity.y != 0:
			player_animation.play("jump")
		else:
			player_animation.play("walk")
			
	player_animation.flip_h = true if direction < 0 else false

	# jump
	if Input.is_action_just_pressed("Jump") and is_on_floor():
		#if not is_casting:
			#player_animation.play("jump")
		velocity.y = JUMP_FORCE

	# attaques
	if Input.is_action_just_pressed("Attack_1"):
		print("attaque 1")
		is_casting = true
		player_animation.play("attack_1")

	if Input.is_action_just_pressed("Attack_2"):
		print("attaque 2")
		is_casting = true
		player_animation.play("attack_2")

	move_and_slide()


func _on_player_animation_animation_finished() -> void:
	print(player_animation.animation)
	if player_animation.animation != "attack_1" && player_animation.animation != "attack_2":
		return
	print("fin aniamtion: ", player_animation.animation)
	shoot()
	is_casting = false
	
func shoot():
	spell = spell_scene.instantiate()
	spell.global_position = muzzle.global_position
	spell.global_rotation = muzzle.global_rotation
	
	if spell.has_method("setup"):
		spell.setup(SPEED*2, damage, attack_range)
	get_tree().current_scene.add_child(spell)
	attack_animation = spell.get_node("AttackAnimation")
	attack_animation.play("charge_1_start") if player_animation.animation == "attack_1" else attack_animation.play("charge_2")
