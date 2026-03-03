extends Node2D

var server := UDPServer.new()
var port := 4280

var rect1 : ColorRect
var rect2 : ColorRect

func _ready():
	server.listen(port)
	
	rect1 = ColorRect.new()
	rect1.color = Color.MEDIUM_PURPLE
	rect1.size = Vector2(20, 20)
	add_child(rect1)
	
	rect2 = ColorRect.new()
	rect2.color = Color.CYAN
	rect2.size = Vector2(20, 20)
	add_child(rect2)

func _process(_delta):
	server.poll()
	if server.is_connection_available():
		var peer : PacketPeerUDP = server.take_connection()
		var packet = peer.get_packet()
		var message = packet.get_string_from_utf8()
		
		var coords = message.split(",")
		
		var viewport_size = get_viewport_rect().size
		
		if coords.size() == 4:
			rect1.position.x = coords[0].to_float() * viewport_size.x
			rect1.position.y = coords[1].to_float() * viewport_size.y
			rect2.position.x = coords[2].to_float() * viewport_size.x
			rect2.position.y = coords[3].to_float() * viewport_size.y
