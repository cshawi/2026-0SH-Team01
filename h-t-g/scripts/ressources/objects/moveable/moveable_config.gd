extends BaseObject
class_name MoveableConfig

@export_group("Physique")
@export var vitess: float = 0.0
@export var friction: float = 0.8
@export var bounce: float = 0.0
@export var push_force_required: float = 5.0

@export_group("Interaction")
@export var is_destructible: bool = false
@export var damage_on_impact: int = 0

@export_group("Feedback")
@export var spawn_particles_on_impact: bool = false
