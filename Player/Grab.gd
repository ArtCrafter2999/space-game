extends Node3D

@onready var interact_ray_cast: RayCast3D = $InteractRayCast
@onready var grab_marker: Marker3D = $GrabMarker
@export var min_distance = 1
@export var max_distance = 3
@export var scroll_mult = 0.15
@export var rotate_mult = 2
@export var rotate_speed = .2
@export var throw_strengh = 15

var _grabbed_body: Grabbable = null;
var _rotate = 0;

func _unhandled_input(event: InputEvent) -> void:
	var _wheel_axis = Input.get_axis("Wheel Down", "Wheel Up");
	if(_wheel_axis == 0): return;
	if not Input.is_action_pressed("Change to Rotation"):
		grab_marker.position.z = clamp(grab_marker.position.z - scroll_mult * _wheel_axis, -max_distance, -min_distance) 
	elif (_grabbed_body):
		_rotate += rotate_mult * _wheel_axis;

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("Interact"):
		var col: Object = interact_ray_cast.get_collider()
		if(col is Grabbable):
			_grabbed_body = col;
			_grabbed_body.grab();
		if(col is Interactable):
			col.interact();
	
	if !_grabbed_body: return;
	_grabbed_body._get_object_position()
	if _rotate != 0:
		_grabbed_body.object_rotation.y += _rotate;
		_rotate = 0
	if Input.is_action_pressed("Interact"):
		#_grabbed_body.object_position = (grab_marker.global_position - _grabbed_body.global_position) * 10 / _grabbed_body.get_mass();
		_grabbed_body.object_position = grab_marker.global_position
	if Input.is_action_just_released("Interact") || Input.is_action_just_pressed("Throw"): 
		_grabbed_body.release()
		if Input.is_action_just_pressed("Throw"):
			_grabbed_body.throw((grab_marker.global_position - global_position).normalized() * throw_strengh / _grabbed_body.get_mass())
		_grabbed_body = null;
