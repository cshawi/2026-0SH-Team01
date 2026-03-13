extends Node2D

var server := UDPServer.new()
var port := 4280
var active_peer : PacketPeerUDP = null

var hand_position := Vector2.ZERO
var is_pinching := false
var last_pinch := false
var pinching_distance := 0.05
var buffer_timer := 0
var buffer_delay := 0.4

func _ready():
	server.listen(port)

func _process(_delta):
	server.poll()
	
	if server.is_connection_available():
		active_peer = server.take_connection()
		
	if active_peer:
		while active_peer.get_available_packet_count() > 0:
			var packet = active_peer.get_packet()
			_update_data(packet.get_string_from_utf8(), _delta)
	
func _update_data(message: String, _delta):
	var coords = message.split(",")
	if coords.size() == 4:
		var point1 = Vector2(coords[0].to_float(), coords[1].to_float())
		var point2 = Vector2(coords[2].to_float(), coords[3].to_float())
		
		var viewport_size = get_viewport_rect().size
		
		var dist = point1.distance_to(point2)
		
		if dist < pinching_distance:
			last_pinch = true
			buffer_timer = buffer_delay
		elif dist > pinching_distance * 1.3:
			last_pinch = false
			buffer_timer = buffer_delay
			
		if buffer_timer > 0:
			buffer_timer -= _delta
		else:
			is_pinching = last_pinch
		
		hand_position.x = (point1.x + point2.x) / 2.0 * viewport_size.x
		hand_position.y = (point1.y + point2.y) / 2.0 * viewport_size.y
