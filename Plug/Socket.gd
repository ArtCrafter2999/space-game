extends Area3D
class_name Socket

@export var type = "electrical"
@export var plug_place: Node3D
var plug: Plug = null
var cool_down : float;

func _on_area_entered(area: Area3D) -> void:
	if not plug and \
	 cool_down <= 0 and \
	 area is PlugArea and \
	 area.plug.type == type:
		plug_in(area.plug);
		
func _physics_process(delta: float) -> void:
	if plug == null: 
		if(cool_down > 0):
			cool_down -= delta;
		return;
	
	plug.body.global_position = plug_place.global_position;
	plug.body.global_rotation = plug_place.global_rotation

func plug_in(new_plug: Plug):
	plug = new_plug;
	plug.socket = self;
	plug.release();
	plug.body.freeze = true;

func plug_out():
	cool_down = 1;
	plug.body.freeze = false;
	plug.socket = null;
	plug = null;
