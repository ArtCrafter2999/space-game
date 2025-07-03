extends StateBase

@export var top_speed: float = 4
@export var acceleration: float = 5
@export var sprint_multiplier: float = 1.6
@export var gravity_state: StateBase;

@onready var gravity_listener: GravityListener = $"../../GravityListener"
@onready var player: Player = $"../.."
@onready var inputs: Inputs = $"../../Inputs"

func physics_process(delta: float) -> void:
	if not gravity_listener.gravity_limit:
		machine.change_state(gravity_state)
		return;
	
	var direction = Vector3.ZERO;
	var sprint_mult = sprint_multiplier if inputs.sprint else 1
	
	var side = player.transform.basis.x * inputs.input_dir.x
	var forward = player.transform.basis.z * inputs.input_dir.y
	direction = (side + forward).normalized()
	
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
