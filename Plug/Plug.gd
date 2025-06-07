@tool
extends GrabRigidBody
class_name Plug

@export var type = "electrical"
@export var data: Dictionary

var socket: Socket = null
var is_plugged: bool:
	get:
		return socket != null;

func _ready() -> void:
	super._ready();
	on_grab.connect(_handle_grab)

func _handle_grab() -> void:
	if(socket):
		socket.plug_out();

func _enter_tree() -> void:
	if Engine.is_editor_hint():
		update_configuration_warnings();

func _get_configuration_warnings() -> PackedStringArray:
	var array = find_children("*", "PlugArea", true, false)
	if(array.is_empty()):
		return ["Plug should contain PlugArea as a child"]
	return []
