extends Node3D

@onready var interact_ray_cast: RayCast3D = $InteractRayCast
@onready var grab_marker: Marker3D = $GrabMarker
@export var min_distance = 1
@export var max_distance = 3
@export var scroll_mult = 0.15
@export var rotate_mult = 2
@export var rotate_speed = .2
@export var throw_strengh = 15

var _grabbed_body: Grabbable = null:
	get: 
		return _grabbed_body;

func setGrabbedBody(value: Node3D):
	_rpc_setGrabbedBody.rpc(value.get_path() if value else null)
@rpc("any_peer", "call_local")
func _rpc_setGrabbedBody(value):
	var object = null;
	if value:
		object = get_node(value)
	_grabbed_body = object;

	
var _rotate = 0;

@onready var multiplayer_synchronizer: MultiplayerSynchronizer = %"MultiplayerSynchronizer"

func _unhandled_input(event: InputEvent) -> void:
	if not multiplayer_synchronizer.is_multiplayer_authority(): return;
	var _wheel_axis = Input.get_axis("Wheel Down", "Wheel Up");
	if(_wheel_axis == 0): return;
	if not Input.is_action_pressed("Change to Rotation"):
		grab_marker.position.z = clamp(grab_marker.position.z - scroll_mult * _wheel_axis, -max_distance, -min_distance) 
	elif (_grabbed_body):
		_rotate += rotate_mult * _wheel_axis;

func _physics_process(delta: float) -> void:
	if multiplayer.has_multiplayer_peer() and not multiplayer_synchronizer.is_multiplayer_authority(): return;
	
	if Input.is_action_just_pressed("Interact") or \
	 Input.is_action_just_pressed("Grab"):
		var col: Object = interact_ray_cast.get_collider()
		if not _grabbed_body and Input.is_action_just_pressed("Grab") and \
		 col is Grabbable:
			setGrabbedBody(col);
			_grabbed_body.grab();
			return;
		if Input.is_action_just_pressed("Interact") and \
		 col is Interactable:
			col.interact();
	
	if not _grabbed_body: return;
	_grabbed_body._get_object_position()
	if _rotate != 0:
		_grabbed_body.object_rotation.y += _rotate;
		_rotate = 0
	
	_grabbed_body.object_position = grab_marker.global_position
	if Input.is_action_just_pressed("Grab") || Input.is_action_just_pressed("Use"): 
		_grabbed_body.release()
		if Input.is_action_just_pressed("Use"):
			_grabbed_body.throw((grab_marker.global_position - global_position).normalized() * throw_strengh / _grabbed_body.get_mass())
		setGrabbedBody(null)
		#_grabbed_body = null;
