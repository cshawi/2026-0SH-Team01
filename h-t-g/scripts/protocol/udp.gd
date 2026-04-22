extends Node2D

var server := UDPServer.new()
var port := 4280
var active_peer : PacketPeerUDP = null

var hand_screen_position := Vector2.ZERO
var is_pinching := false
var last_pinch := false
var pinching_distance := 0.1
var buffer_timer := 0.0
var buffer_delay := 0.1

func _ready():
	server.listen(port)

func _process(delta):
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

func _update_data(message: String):
	if GameMaster.mouse_mode: return
	
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
