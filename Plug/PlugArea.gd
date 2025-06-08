@tool
extends Area3D
class_name PlugArea

@export var plug: Plug:
	get: 
		return plug;
	set(value):
		plug = value;
		if Engine.is_editor_hint():
			update_configuration_warnings();
		

var socket: Socket = null
var is_plugged: bool:
	get:
		return socket != null;

func _ready() -> void:
	if(!plug):
		var parent = get_parent();
		assert(parent is Plug, "Either parent should be Plug type or plug should be set")
		plug = parent as Plug

func _enter_tree() -> void:
	if(!plug):
		if($".." is not Plug):
			update_configuration_warnings()

func _get_configuration_warnings() -> PackedStringArray:
	if(plug): return [];
	var parent = get_parent()
	if(parent is not Plug):
		return ["PlugArea should contain Plug, as a parent, to work properly"]
	return []
