extends Area3D
class_name Plug

@export var _body: Node3D
@export var grab_body: GrabBody
@export var type = "electrical"

var socket: Socket = null
var is_plugged: bool:
	get:
		return socket != null;

func _ready() -> void:
	if(!_body):
		_body = $".."
	if(!grab_body):
		if($".." is GrabBody):
			grab_body = $".." as GrabBody
		else:
			push_error("Grab Body is not set")
	grab_body.on_grab.connect(_handle_grab)

func _handle_grab() -> void:
	if(socket):
		socket.plug_out();
