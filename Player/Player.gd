extends RigidBody3D
class_name Player

@export var sensativity: float = 0.35
@export var top_speed: float = 8
@export var space_multiplier: float = .5
@export var acceleration: float = 5
@export var deceleration: float = 8
@export var sprint_multiplier: float = 1.6
@export var jump_velocity: float = 4.5

@onready var neck: Node3D = $Neck
@onready var sub_neck: Node3D = $Neck/SubNeck
@onready var camera = %Camera;
@onready var on_floor_area: Area3D = $onFloorArea
@onready var gravity_listener: GravityListener = $GravityListener

func _ready() -> void:
	gravity_listener.gravity_changed.connect(handle_gravity_changed)
	
func handle_gravity_changed(gravity: Vector3):
	if(gravity.length() < 1):
		global_rotate(transform.basis.x, neck.rotation.x)
		neck.rotation.x = 0
	else:
		var current = basis.y
		var target = -gravity.normalized();
		
		_cross_product = current.cross(target).normalized();
		_cp_angle = current.signed_angle_to(target, _cross_product);
		#print("cross_product %s; angle %s" % [_cross_product, _cp_angle])

var _esc: bool = true;
var _neck_y_rotation = 0;
var _y_rotation = 0;
var gravity_length: float
var head_x_rotation: float
var body_x_rotation: float

func _unhandled_input(event) -> void: 
	if event is InputEventMouseButton && _esc:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		_esc = false;
	if not _esc && Input.is_action_just_pressed("ui_cancel"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		_esc = true
	
	if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED and \
	event is InputEventMouseMotion:
		var motionEvent: InputEventMouseMotion = event
		_neck_y_rotation = -motionEvent.relative.x * 0.01 * sensativity
		head_x_rotation = -motionEvent.relative.y * 0.01 * sensativity
		

func is_on_floor() -> bool: 
	return on_floor_area.get_overlapping_bodies().size() > 0
	
var _cross_product: Vector3;
var _cp_angle: float = 0
var _cp_angle_left: float = 0
@export var gravity_rotation_speed = 1.5;
func rotate_to_gravity():
	if _cp_angle == 0: return;
	if _cp_angle_left == 0: _cp_angle_left = _cp_angle;
	var rot_angle = _cp_angle * deg_to_rad(gravity_rotation_speed)
	if(_cp_angle_left > rot_angle):
		global_rotate(_cross_product,rot_angle);
		_cp_angle_left -= rot_angle;
	else:
		global_rotate(_cross_product, _cp_angle_left)
		_cp_angle_left = 0;
		_cp_angle = 0;

func _process(delta: float) -> void:
	gravity_length = gravity_listener.calculate_gravity().length()
	
	var no_gravity = gravity_length < 1
	var gravity_limit = no_gravity || gravity_length > 18
	
	if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		if(_neck_y_rotation):
			neck.rotate_y(_neck_y_rotation);
			_y_rotation+=_neck_y_rotation
			_neck_y_rotation=0;
		
		if(head_x_rotation):
			sub_neck.rotate_x(head_x_rotation)
			sub_neck.rotation.x = clamp(sub_neck.rotation.x, deg_to_rad(-90), deg_to_rad(90))
			if(gravity_limit):
				body_x_rotation += head_x_rotation
			head_x_rotation = 0

func _physics_process(delta):
	gravity_length = gravity_listener.calculate_gravity().length()
	#print("gravity %s, velocity %s" % [round(gravity_length), round(linear_velocity.length())])
	
	var direction = Vector3.ZERO;
	var sprint_mult = sprint_multiplier if Input.is_action_pressed("Sprint") else 1
	var no_gravity = gravity_length < 1
	var gravity_limit = no_gravity || gravity_length > 18
	rotate_to_gravity()
	if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		if(_neck_y_rotation):
			global_rotate(transform.basis.y, _y_rotation);
			neck.rotate_y(-_y_rotation);
			_y_rotation = 0;
		
		if body_x_rotation:
			if gravity_limit: 
				global_rotate(transform.basis.x, sub_neck.rotation.x);
				sub_neck.rotation.x = 0;
			else:
				global_rotate(transform.basis.x, body_x_rotation);
				sub_neck.rotate_x(-body_x_rotation);
			body_x_rotation = 0
		
		var input_dir = Input.get_vector("Left", "Right", "Forward", "Backward")
		var side = transform.basis.x * input_dir.x
		var forward = transform.basis.z * input_dir.y
		direction = (side + forward).normalized()
		var jump: Vector3 = Vector3.ZERO
		if Input.is_action_just_pressed("Jump") and is_on_floor():
			apply_central_impulse(jump_velocity * transform.basis.y)
	
	var opt_space_mult = space_multiplier if gravity_limit else 1 
	var target_movement : Vector3 = (direction * top_speed * sprint_mult * opt_space_mult);
	var speed_dif : Vector3 = target_movement - linear_velocity * (Vector3(1, 1, 1) if gravity_limit else Vector3.ONE - basis.y)
	var accel_rate = acceleration if target_movement.length() > 0.01 else (0 if gravity_limit else deceleration);
	var movement : Vector3 = speed_dif * accel_rate;
	apply_central_force(movement)
