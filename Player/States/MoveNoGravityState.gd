extends StateBase

@export var top_speed: float = 4
@export var acceleration: float = 5
@export var sprint_multiplier: float = 1.6
@export var jump_velocity: float = 4.5
@export var gravity_state: StateBase;

@onready var gravity_listener: GravityListener = $"../../GravityListener"
@onready var player: Player = $"../.."
@onready var inputs: Inputs = $"../../Inputs"
@onready var on_floor_area: Area3D = $"../../onFloorArea"
@onready var sub_neck: Node3D = $"../../Neck/SubNeck"

func physics_process(delta: float) -> void:
	if not gravity_listener.gravity_limit:
		machine.change_state(gravity_state)
		return;
	
	var direction = Vector3.ZERO;
	var sprint_mult = sprint_multiplier if inputs.sprint else 1
	
	
	var side = sub_neck.global_basis.x * inputs.input_dir.x
	var forward = sub_neck.global_basis.z * inputs.input_dir.y
	direction = (side + forward).normalized()
	var jump: Vector3 = Vector3.ZERO
	if inputs.jump and is_on_floor():
		player.apply_central_impulse(jump_velocity * sub_neck.global_basis.y)
	
	# Максимальна швидкість з модифікаторами 
	var target_movement : Vector3 = (direction * top_speed * sprint_mult);
	
	# Поточна швидкість гравця для додавання прискорення або сповільнення
	var drag = player.linear_velocity
	
	# Різниця максимальної швидкості від поточної
	var speed_dif : Vector3 = target_movement - drag
	# Присткорення або сповільнення в залежності від input. Не сповільнюється в невагомості
	var accel_rate = acceleration if target_movement.length() > 0.01 else 0;
	var movement : Vector3 = speed_dif * accel_rate;
	player.apply_central_force(movement)

func is_on_floor() -> bool: 
	return on_floor_area.get_overlapping_bodies().size() > 0
