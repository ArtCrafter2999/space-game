extends Node3D

@onready var inputs: Inputs = $"../Inputs"
@onready var sub_neck: Node3D = $SubNeck
@onready var gravity_listener: GravityListener = $"../GravityListener"
@onready var player: Player = $".."

var _y_rotation = 0;
var body_x_rotation: float

func _process(delta: float) -> void:
	if inputs.mouse.x:
		rotate_y(inputs.mouse.x);
		_y_rotation+=inputs.mouse.x
		#_neck_y_rotation=0;
		
	if inputs.mouse.y:
		sub_neck.rotate_x(inputs.mouse.y)
		sub_neck.rotation.x = clamp(sub_neck.rotation.x, deg_to_rad(-90), deg_to_rad(90))
		if gravity_listener.gravity_limit:
			body_x_rotation += inputs.mouse.y
		#head_x_rotation = 0
	inputs.mouse = Vector2.ZERO
	
func _physics_process(delta: float) -> void:
	if inputs.mouse.x:
		player.global_rotate(player.transform.basis.y, _y_rotation);
		rotate_y(-_y_rotation);
		_y_rotation = 0;
	
	if body_x_rotation:
		if gravity_listener.gravity_limit: 
			player.global_rotate(player.transform.basis.x, sub_neck.rotation.x);
			sub_neck.rotation.x = 0;
		else:
			player.global_rotate(player.transform.basis.x, body_x_rotation);
			sub_neck.rotate_x(-body_x_rotation);
		body_x_rotation = 0
