extends CharacterBody2D
class_name BaseEnemy

signal died

@onready var velocity_component: VelocityComponent = $VelocityComponent
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite
@onready var detection_zone: Area2D = $DetectionZone
@onready var hitbox_component: HitboxComponent = $HitboxComponent
@onready var spawner: Spawner = $Spawner

@export var max_health: int = 3
@export var damage: int = 1
@export var speed: float = 100.0
@export var detection_radius := 120.0
@export var loot: PackedScene

var current_health: int
var is_dead: bool = false
var player = null

func _ready() -> void:
	var area = detection_zone.get_child(0)
	if area:
		area.shape.radius = detection_radius
	detection_zone.body_entered.connect(_on_body_entered)
	detection_zone.body_exited.connect(_on_body_exited)

func _on_body_entered(body: Node2D):
	if body is Player:
		player = body
		if has_method("on_player_detected"):
			call("on_player_detected")

func _on_body_exited(body: Node2D):
	if body == player:
		player = null
		if has_method("on_player_lost"):
			call("on_player_lost")
