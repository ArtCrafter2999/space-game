extends Node3D
class_name GrabBody

var object_rotation: Vector3:
	get:
		return _get_object_rotation();
	set(value):
		_set_object_rotation(value)
		
var object_position: Vector3:
	get:
		return _get_object_position()
	set(value):
		_set_object_position(value);
		
signal on_grab
signal on_release

func _get_object_rotation() -> Vector3:
	return global_rotation;
	
func _set_object_rotation(value: Vector3):
	global_rotation = value;
	
func _get_object_position() -> Vector3:
	return global_position;
	
func _set_object_position(value: Vector3):
	global_position = value;

func grab():
	on_grab.emit();
	pass

func release():
	on_release.emit();
	pass

func throw(impulse: Vector3):
	pass

func get_mass() -> float:
	return 1;
	
