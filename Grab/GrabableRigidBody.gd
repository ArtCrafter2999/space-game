@tool
extends Grabbable
class_name GrabbableRigidBody

@export var body: RigidBody3D:
	get: 
		return body
	set(value):
		body = value
		if Engine.is_editor_hint():
			update_configuration_warnings();
@export var grab_strengh_multiplier: float = 1
@export_range(0, 100) var grabbed_angular_damp: float = 3
@export_flags_3d_physics var grabbed_colision_layer: int = 4
@export_flags_3d_physics var grabbed_colision_mask: int = 5

var _prev_angular_damp: float
var _prev_colision_layer: int
var _prev_colision_mask: int
	
func _ready() -> void:
	if(body == null):
		var parent = get_parent();
		assert(parent is RigidBody3D, 
			"%s: Either parent should be RigidBody3D or body should be set" %
			name
		)
		body = parent as RigidBody3D;
	_prev_angular_damp = body.angular_damp
	_prev_colision_layer = body.collision_layer
	_prev_colision_mask = body.collision_mask

func _get_object_rotation() -> Vector3:
	return body.angular_velocity;
	
func _set_object_rotation(value: Vector3):
	body.angular_velocity = value;
	
func _set_object_position(value: Vector3):
	body.linear_velocity = (value - body.global_position) * 10 * grab_strengh_multiplier / get_mass();
	
func grab():
	super.grab();
	_prev_angular_damp = body.angular_damp
	_prev_colision_layer = body.collision_layer
	_prev_colision_mask = body.collision_mask
	body.angular_damp = grabbed_angular_damp
	body.collision_layer = grabbed_colision_layer
	body.collision_mask = grabbed_colision_mask

func release():
	super.release();
	body.angular_damp = _prev_angular_damp
	body.collision_layer = _prev_colision_layer
	body.collision_mask = _prev_colision_mask

func throw(impulse: Vector3):
	body.linear_velocity = impulse * grab_strengh_multiplier;

func get_mass() -> float:
	return body.mass / max(body.gravity_scale, 0.2);
	
func _enter_tree() -> void:
	if Engine.is_editor_hint():
		var parent = get_parent();
		var selfRigidBody = self
		if selfRigidBody is RigidBody3D:
			body = selfRigidBody;
		if(parent is RigidBody3D):
			body = parent;
		update_configuration_warnings()

func _get_configuration_warnings() -> PackedStringArray:
	if not body:
		return ["Either parent should be RigidBody3D or body should be set"]
	return []
