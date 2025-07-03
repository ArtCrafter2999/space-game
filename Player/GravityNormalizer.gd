extends Node

@export var gravity_rotation_speed = 1.5;

@onready var gravity_listener: GravityListener = $"../GravityListener"
@onready var player: Player = $".."
@onready var neck: Node3D = $"../Neck"

var _cross_product: Vector3;
var _cp_angle: float = 0
var _cp_angle_left: float = 0

func _physics_process(delta: float) -> void:
	_rotate_to_gravity();

func _rotate_to_gravity():
	if(gravity_listener.gravity_vector.length_squared() < 1):
		player.global_rotate(player.transform.basis.x, neck.rotation.x)
		neck.rotation.x = 0
	else:
		var current = player.basis.y
		var target = -gravity_listener.gravity_vector.normalized();
		
		_cross_product = current.cross(target).normalized();
		_cp_angle = current.signed_angle_to(target, _cross_product);
	
	if _cp_angle == 0: return;
	if _cp_angle_left == 0: _cp_angle_left = _cp_angle;
	var rot_angle = _cp_angle * deg_to_rad(gravity_rotation_speed)
	if(_cp_angle_left > rot_angle):
		player.global_rotate(_cross_product,rot_angle);
		_cp_angle_left -= rot_angle;
	else:
		player.global_rotate(_cross_product, _cp_angle_left)
		_cp_angle_left = 0;
		_cp_angle = 0;
