extends Area3D
class_name Grabbable

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
signal on_grab_with_authority(playerId: int)
signal on_release

func _get_object_rotation() -> Vector3:
	return global_rotation;
	
func _set_object_rotation(value: Vector3):
	global_rotation = value;
	
func _get_object_position() -> Vector3:
	return global_position;
	
func _set_object_position(value: Vector3):
	global_position = value;

func grab(playerId: int = multiplayer.get_unique_id()):
	on_grab.emit();
	on_grab_with_authority.emit(playerId)
	pass

func release():
	on_release.emit();
	pass

func throw(impulse: Vector3):
	pass

func get_mass() -> float:
	return 1;
	
