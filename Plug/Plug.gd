@tool
extends Node3D
class_name Plug

@export var type = "electrical"
@export var data: Dictionary
@onready var grabbable: GrabbableRigidBody = %Grabbable

var socket: Socket = null
var is_plugged: bool:
	get:
		return socket != null;

func unplug() -> void:
	if(socket):
		socket.plug_out();

func _enter_tree() -> void:
	if Engine.is_editor_hint():
		update_configuration_warnings();

func _get_configuration_warnings() -> PackedStringArray:
	var errors = []
	if(find_children("*", "PlugArea", true, false).is_empty()):
		errors.append("Plug should contain PlugArea as a child")
	return errors
