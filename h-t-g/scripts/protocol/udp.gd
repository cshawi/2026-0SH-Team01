extends Node2D

const HAND_TRACKING_NAME := "hand_tracking"
const HAND_TRACKING_DEBUG_NAME := "hand_tracking"

var server := UDPServer.new()
var port := 4280
var active_peer: PacketPeerUDP = null

var available_cameras: Array = []
var camera_scan_thread: Thread = null
var is_scanning_cameras := false

var hand_screen_position := Vector2.ZERO
var is_pinching := false
var last_pinch := false
var pinching_distance := 0.1
var buffer_timer := 0.0
var buffer_delay := 0.1

signal cameras_cached


func _ready() -> void:
	server.listen(port)


func _process(delta: float) -> void:
	server.poll()

	if server.is_connection_available():
		active_peer = server.take_connection()

	if active_peer:
		while active_peer.get_available_packet_count() > 0:
			var packet = active_peer.get_packet()
			_update_data(packet.get_string_from_utf8())

	if buffer_timer > 0:
		buffer_timer -= delta
	else:
		is_pinching = last_pinch


func _update_data(message: String) -> void:
	if GameMaster.mouse_mode:
		return

	var coords = message.split(",")

	if coords.size() == 4:
		var point1 = Vector2(coords[0].to_float(), coords[1].to_float())
		var point2 = Vector2(coords[2].to_float(), coords[3].to_float())

		var dist = point1.distance_to(point2)

		var current_detection = dist < pinching_distance
		if current_detection != last_pinch:
			last_pinch = current_detection
			buffer_timer = buffer_delay

		var viewport_size = get_viewport().get_visible_rect().size
		hand_screen_position = Vector2(
			(point1.x + point2.x) / 2.0 * viewport_size.x,
			(point1.y + point2.y) / 2.0 * viewport_size.y
		)


func get_hand_tracking_filename(debug := false) -> String:
	var file_name := HAND_TRACKING_DEBUG_NAME if debug else HAND_TRACKING_NAME

	if OS.has_feature("windows"):
		file_name += ".exe"

	return file_name


func get_hand_tracking_path() -> String:
	if OS.has_feature("editor"):
		var debug_file := get_hand_tracking_filename(true)
		return ProjectSettings.globalize_path("res://../ht-udp/dist/" + debug_file)

	var release_file := get_hand_tracking_filename(false)
	return OS.get_executable_path().get_base_dir().path_join(release_file)


func get_available_cameras() -> Array:
	var output := []
	var exe_path = get_hand_tracking_path()

	var exit_code := OS.execute(
		exe_path,
		["--list-cameras"],
		output,
		true,
		false
	)

	if exit_code != 0 or output.is_empty():
		return []

	var raw_output = output[0]
	var lines = raw_output.split("\n", false)
	var json_text := ""

	for i in range(lines.size() - 1, -1, -1):
		var line = lines[i].strip_edges()

		if line.begins_with("[") and line.ends_with("]"):
			json_text = line
			break

	if json_text == "":
		return []

	var json := JSON.new()
	var parse_result := json.parse(json_text)

	if parse_result != OK:
		return []

	return json.data

func cache_available_cameras_async() -> void:
	if is_scanning_cameras:
		return

	is_scanning_cameras = true
	camera_scan_thread = Thread.new()
	camera_scan_thread.start(_scan_cameras_thread)

func _scan_cameras_thread() -> void:
	var cameras := get_available_cameras()
	call_deferred("_finish_camera_scan", cameras)


func _finish_camera_scan(cameras: Array) -> void:
	available_cameras = cameras
	is_scanning_cameras = false

	if camera_scan_thread != null:
		camera_scan_thread.wait_to_finish()
		camera_scan_thread = null

	print("avaible cameras : ", available_cameras)
	cameras_cached.emit()
