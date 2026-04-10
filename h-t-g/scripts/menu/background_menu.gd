extends Control
class_name BackgroundColor

@export_group("Sky Settings")
@export var sky_colors = {
	"white": "#ffffff",
	"blue": "#00b1ff",
	"red": "#ff6676"
}
@export var color_sequence : Array[String] = ["white", "red", "blue", "red"]

@export_group("Orbit Settings")
@export var orbit_height := 375.0
@export var transition_time := 60.0

@onready var sky: ColorRect = $Sky
@onready var orbit_center: Marker2D = $OrbitCenter
@onready var sun_pivot: Node2D = $SunPivot
@onready var sun_sprite: Sprite2D = $SunPivot/SunSprite
@onready var moon_pivot: Node2D = $MoonPivot
@onready var moon_sprite: Sprite2D = $MoonPivot/MoonSprite

var orbit_speed := 0.0
var current_color_index := 0

func _ready() -> void:
	sun_pivot.global_position = orbit_center.global_position
	moon_pivot.global_position = orbit_center.global_position
	
	# Le soleil commence à 180° (gauche)
	# La lune commence à 0° (droite) pour être à l'opposé
	sun_pivot.rotation = deg_to_rad(180)
	moon_pivot.rotation = deg_to_rad(0)
	
	# On décale les sprites sur l'axe X pour qu'ils suivent l'arc de cercle
	sun_sprite.position.x = orbit_height
	moon_sprite.position.x = orbit_height
	
	orbit_speed = deg_to_rad(360.0 / transition_time)
	
	if color_sequence.size() > 0:
		sky.color = Color(sky_colors[color_sequence[0]])
		start_color_cycle()

func _physics_process(delta: float) -> void:
	sun_pivot.rotation += orbit_speed * delta
	moon_pivot.rotation += orbit_speed * delta
	
	# On annule la rotation sur les sprites pour qu'ils restent droits
	sun_sprite.rotation = -sun_pivot.rotation
	moon_sprite.rotation = -moon_pivot.rotation

func start_color_cycle() -> void:
	current_color_index = (current_color_index + 1) % color_sequence.size()
	var target_color = Color(sky_colors[color_sequence[current_color_index]])
	var step_duration = transition_time / color_sequence.size()
	
	var tween = create_tween()
	tween.tween_property(sky, "color", target_color, step_duration).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tween.finished.connect(start_color_cycle)
