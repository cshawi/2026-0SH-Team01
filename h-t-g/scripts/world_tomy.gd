extends Node2D
class_name World_Tomy

@onready var limit_wall: LimitWall = $LimitWall
@onready var spawner: Node2D = $Spawner
@onready var hint_area: Area2D = $HintArea
@onready var hint_area_2: Area2D = $HintArea2
@onready var hint_area_3: Area2D = $HintArea3
@onready var object = preload("res://scenes/moveables/full_motion_object.tscn")
@onready var small_box = preload("res://ressources/objects/Box/small_box.tres")
@onready var roll_player_help: RollPlayerHelp = $RollPlayerHelp
@onready var roll_player_help_2: RollPlayerHelp = $RollPlayerHelp2
@onready var player_spawn_point: Marker2D = $PlayerSpawnPoint


const BOX_AMOUNT := 6

@onready var player_path := preload("res://scenes/Player_scenes/player.tscn")
var player: Player
var player_view: Camera2D
var has_player := true

signal level_finished() #mettre ne paramètre player.current_hp


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	limit_wall.add_wall(0)
	limit_wall.add_wall(1280)
	
	player = spawner.spawn(player_path, player_spawn_point.global_position)
	player_view = player.get_node("PlayerView")
	player_view.limit_left = limit_wall.get_child(0).shape.a.x
	player_view.limit_right = limit_wall.get_child(1).shape.a.x
	
	Hud.hide_all_menu()
	GameMaster.register_level(self)



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_hint_area_body_entered(body: Node2D) -> void:
	if body is Player:
		hint_area.queue_free()
		roll_player_help.set_message("Oh non!!! Une énorme roche bloque le passage... Servez-vous de ces boîtes et de votre magie pour passer.")
		roll_player_help.show_message()
		for i in range(BOX_AMOUNT):
			spawner.spawn(object, Vector2(randi_range(150, 250), -50), small_box)
			await get_tree().create_timer(0.25).timeout


func _on_hint_area_2_body_entered(body: Node2D) -> void:
	if body is Player:
		hint_area_2.queue_free()
		roll_player_help_2.set_message("Une autre roche bloque le passage, mais elle semble moins lourde... Tentez de la soulever et de passer.")
		roll_player_help_2.show_message()


func _on_hint_area_3_body_entered(body: Node2D) -> void:
	if body is Player:
		await get_tree().create_timer(1).timeout
		level_finished.emit()
		
