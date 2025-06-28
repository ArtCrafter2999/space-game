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
@onready var on_floor_area: Area3D = $onFloorArea
@onready var gravity_listener: GravityListener = $GravityListener
@onready var multiplayer_synchronizer: MultiplayerSynchronizer = %"MultiplayerSynchronizer"
@onready var camera: Camera3D = %Camera

func _ready() -> void:
	gravity_listener.gravity_changed.connect(handle_gravity_changed)
	multiplayer_synchronizer.set_multiplayer_authority(int(name))
	if multiplayer_synchronizer.is_multiplayer_authority():
		camera.current = true;
	
func handle_gravity_changed(gravity: Vector3):
	if not multiplayer_synchronizer.is_multiplayer_authority(): return;
	if(gravity.length() < 1):
		global_rotate(transform.basis.x, neck.rotation.x)
		neck.rotation.x = 0
	else:
		var current = basis.y
		var target = -gravity.normalized();
		
		_cross_product = current.cross(target).normalized();
		_cp_angle = current.signed_angle_to(target, _cross_product);

var _esc: bool = true;
var _neck_y_rotation = 0;
var _y_rotation = 0;
var gravity_length: float
var head_x_rotation: float
var body_x_rotation: float

func _unhandled_input(event) -> void: 
	if not multiplayer_synchronizer.is_multiplayer_authority(): return;
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
	if not multiplayer_synchronizer.is_multiplayer_authority(): return;
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
	if not multiplayer_synchronizer.is_multiplayer_authority(): return;
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
	if multiplayer_synchronizer.is_multiplayer_authority() and not multiplayer.is_server():
		print(position)
	
	if not multiplayer_synchronizer.is_multiplayer_authority(): return;
	gravity_length = gravity_listener.calculate_gravity().length()
	
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
	
	# Скоротити швидкість з якою переміщуюсь в невагомості
	var opt_space_mult = space_multiplier if gravity_limit else 1
	# Максимальна швидкість з модифікаторами 
	var target_movement : Vector3 = (direction * top_speed * sprint_mult * opt_space_mult);
	
	# Поточна швидкість гравця для додавання прискорення або сповільнення
	var drag = linear_velocity
	if not gravity_limit: 
		# Якщо гравець в гравтації, не додавати відносний Y щоб не було багів по цьому
		drag -= -basis.y * linear_velocity.dot(-basis.y)
	
	# Різниця максимальної швидкості від поточної
	var speed_dif : Vector3 = target_movement - drag
	# Присткорення або сповільнення в залежності від input. Не сповільнюється в невагомості
	var accel_rate = acceleration if target_movement.length() > 0.01 else (0 if gravity_limit else deceleration);
	var movement : Vector3 = speed_dif * accel_rate;
	apply_central_force(movement)
