extends RigidBody3D
@onready var door: GrabbableRigidBody = $Door/Grabbable
var _grabbed = false;
var door_locked = true;
@onready var lock_joint: PinJoint3D = $LockJoint
@onready var plug: Plug = $Plug
@onready var lights: OmniLight3D = $OmniLight3D

func _ready() -> void:
	door.on_grab.connect(_handle_door_grab)
	door.on_release.connect(_handle_door_release)
	
func _handle_door_grab():
	if(_grabbed): return
	freeze = true;
	door_locked = false;

func _handle_door_release():
	if(_grabbed): return
	freeze = false;

func grab():
	_grabbed = true;
	if multiplayer.is_server():
		door.grab();
	
func release():
	_grabbed = false;
	if multiplayer.is_server():
		door.release();

func _physics_process(delta: float) -> void:
	var door_rotation = floor(rad_to_deg(door.body.rotation.y));
	if(door_rotation > -2 && door_rotation < 20 && !freeze):
		door_locked = true;
	if(door_locked):
		door.body.collision_layer = 0
		door.body.collision_mask = 0
		lock_joint.node_a = get_path();
		lock_joint.node_b = door.body.get_path();
	else:
		if(!freeze):
			door.body.collision_layer = collision_layer
			door.body.collision_mask = collision_mask
		lock_joint.node_a = "";
		lock_joint.node_b = "";
	
	if not door_locked and \
	 (door_rotation < -3 or door_rotation > 10) and \
	 plug.receive_data("electricity"):
		lights.visible = true;
	else:
		lights.visible = false;
