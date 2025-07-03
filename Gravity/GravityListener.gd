extends Area3D
class_name GravityListener

var gravity_vector: Vector3:
	get: 
		return gravity_vector;
	set(value):
		if gravity_vector != value:
			gravity_vector = value;
			gravity_changed.emit(value)

var gravity_limit: bool:
	get:
		var gravity_length = gravity_vector.length_squared()
		return gravity_length < 1 or gravity_length > 324 # 18 squared
		
var gravity_areas: Array[Area3D] = []

signal gravity_changed(Vector3)

func _physics_process(delta: float) -> void:
	gravity_vector = _calculate_gravity()

func _calculate_gravity() -> Vector3:
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
	return result_gravity
