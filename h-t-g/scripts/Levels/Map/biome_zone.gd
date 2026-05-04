extends Area2D
class_name BiomeZone

@export var biome_name: String
@export_file("*.tscn") var target_scene: String
@export var preview_path: NodePath
@export_file("*.ogg") var sound_track: String

@onready var preview: WorldMapPreview

var cursor_inside := false
var click_locked := false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	area_entered.connect(_on_area_entered)
	area_exited.connect(_on_area_exited)

	preview = get_node_or_null(preview_path) as WorldMapPreview

	if preview != null:
		preview.hide()

	call_deferred("update_done_visual")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	# clic curseur magique
	if cursor_inside and (GameMaster.magic_cursor.is_grabing) and not click_locked:
		click_locked = true
		GameMaster.transition_to_music(sound_track)
		await Fade_transition.play_level_transition(GameMaster.change_to_level, target_scene)

	# reset lock
	if not Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) and not GameMaster.magic_cursor.is_grabing:
		click_locked = false



func update_done_visual() -> void:
	if preview == null:
		return

	if GameMaster.completed_levels.has(target_scene):
		preview.show_done()
	else:
		preview.hide_done()
		
func _on_area_entered(area: Area2D):
	if area is MagicCursor:
		cursor_inside = true
		if preview != null: preview.show()
	
	

func _on_area_exited(area: Area2D):
	if area is MagicCursor:
		cursor_inside = false
		if preview != null: preview.hide()
