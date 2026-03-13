extends BaseObject
class_name MoveableConfig

@export_group("Physique")
@export var vitess: float = 0.0
@export var friction: float = 0.8
@export var bounce: float = 0.0
@export var push_force_required: float = 5.0
@export var max_velocity: float = 5.0
@export var gravity_scale: float = 1.0
@export var can_rotate: bool = false
@export var is_static_until_pushed: bool = false

@export_group("Interaction")
@export var can_be_pushed: bool = true
@export var can_be_pulled: bool = false
@export var can_be_carried: bool = false
@export var is_destructible: bool = false
@export var durability: int = 100
@export var damage_on_impact: int = 0

@export_group("Feedback")
@export var move_sound: AudioStream
@export var impact_sound: AudioStream
@export var break_sound: AudioStream
@export var spawn_particles_on_impact: bool = false
