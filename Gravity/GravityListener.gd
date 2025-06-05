extends Area3D
class_name GravityListener

signal gravity_changed(Vector3)

var gravity_areas: Array[Area3D] = []
var _prev_result: Vector3

func calculate_gravity() -> Vector3:
	var clone: Array[Area3D] = gravity_areas.duplicate();
	var result_gravity = Vector3.ZERO
	var replace_priority
	for area in clone:
		if(replace_priority && area.priority <= replace_priority):
			continue;
			
		#Не працює з двома реплейсами
		if(!replace_priority || replace_priority < area.priority) \
			&& area.gravity_space_override == Area3D.SPACE_OVERRIDE_REPLACE:
			replace_priority = area.priority;
			result_gravity = Vector3.ZERO
		var add_gravity = Vector3.ZERO;
		if(area.gravity_point):
			add_gravity += \
				(area.global_position + area.gravity_point_center - global_position)\
				.normalized()
		else:
			add_gravity += area.gravity_direction
		result_gravity = add_gravity * area.gravity
	if(_prev_result != null && result_gravity != _prev_result):
		gravity_changed.emit(result_gravity)
	_prev_result = result_gravity;
	return result_gravity
