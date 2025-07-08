extends RigidBody3D

var direction: Vector3

func move(direction: Vector3):
	self.direction = direction.normalized();

func _physics_process(delta: float) -> void:
	if(Input.is_action_just_pressed("ui_up")):
		self.direction = Vector3.RIGHT
	if(Input.is_action_just_pressed("ui_down")):
		self.direction = Vector3.LEFT
	if(Input.is_action_just_pressed("ui_accept")):
		self.direction = Vector3.ZERO
	apply_central_force(direction)
