extends Area3D
class_name Socket

@export var type = "electrical"
@export var plug_place: Node3D
var plug: Plug = null
var cool_down : float;

func _on_area_entered(area: Area3D) -> void:
	if(cool_down <= 0 && area is Plug && area.type == type):
		plug_in(area);
		
func _physics_process(delta: float) -> void:
	if plug == null: 
		if(cool_down > 0):
			cool_down -= delta;
		return;
	#plug._body.reparent(self)
	plug._body.global_position = plug_place.global_position;
	plug._body.global_rotation = plug_place.global_rotation

func plug_in(new_plug: Plug):
	plug = new_plug;
	plug.socket = self;
	plug.grab_body.release();
	if !(plug._body is RigidBody3D): return;
	var _rigid_body = plug._body as RigidBody3D;
	_rigid_body.freeze = true;

func plug_out():
	print("plug_out")
	cool_down = 1;
	if(plug._body is RigidBody3D):
		var _rigid_body = plug._body as RigidBody3D;
		_rigid_body.freeze = false
	plug.socket = null;
	plug = null;
