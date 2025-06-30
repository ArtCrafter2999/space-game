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
@export_flags_3d_physics var grabbed_self_colision_layer: int = 4
@export_flags_3d_physics var grabbed_self_colision_mask: int = 5
@export_flags_3d_physics var grabbed_other_colision_layer: int = 1
@export_flags_3d_physics var grabbed_other_colision_mask: int = 7

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
	_rpc_set_object_rotation.rpc(value)
@rpc("any_peer", "call_local")
func _rpc_set_object_rotation(value: Vector3):
	body.angular_velocity = value;

func _set_object_position(value: Vector3):
	_rpc_set_object_position.rpc(value)
@rpc("any_peer", "call_local")
func _rpc_set_object_position(value: Vector3):
	body.linear_velocity = (value - body.global_position) * 10 * grab_strengh_multiplier / get_mass();

func grab(playerId: int = multiplayer.get_unique_id()):
	_rpc_grab.rpc(playerId);
@rpc("any_peer", "call_local")
func _rpc_grab(playerId: int = multiplayer.get_unique_id()):
	super.grab(playerId);
	_prev_angular_damp = body.angular_damp
	_prev_colision_layer = body.collision_layer
	_prev_colision_mask = body.collision_mask
	body.angular_damp = grabbed_angular_damp
	if playerId == multiplayer.get_unique_id():
		body.collision_layer = grabbed_self_colision_layer
		body.collision_mask = grabbed_self_colision_mask
	else:
		body.collision_layer = grabbed_other_colision_layer
		body.collision_mask = grabbed_other_colision_mask
		

func release():
	_rpc_release.rpc();
@rpc("any_peer", "call_local")
func _rpc_release():
	super.release();
	body.angular_damp = _prev_angular_damp
	body.collision_layer = _prev_colision_layer
	body.collision_mask = _prev_colision_mask

func throw(impulse: Vector3):
	_rpc_throw.rpc(impulse)
@rpc("any_peer", "call_local")
func _rpc_throw(impulse: Vector3):
	body.linear_velocity = impulse * grab_strengh_multiplier;

func get_mass() -> float:
	assert(body.mass / max(body.gravity_scale, 0.2))
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
