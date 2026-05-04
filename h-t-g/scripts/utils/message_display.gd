extends RichTextLabel
class_name MessageDisplay

@onready var audio_player = $AudioStreamPlayer

var writing := false
var total_characters := 0.0
var last_character := 0

@export var typing_speed := 15.0

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	if writing: write(delta)

func set_message(message: String):
	text = message
	
func show_message():
	writing = true
	
func hide_message():
	writing = false
	total_characters = 0
	last_character = 0
	visible_characters = 0
	
func write(delta: float):
	if total_characters < text.length():
		total_characters += typing_speed * delta
		visible_characters = int(total_characters)
		if last_character != visible_characters:
			last_character = visible_characters
			audio_player.pitch_scale = randf_range(0.9, 1.1)
			audio_player.volume_db = GameMaster.music_volume
			audio_player.play()
	else:
		writing = false
