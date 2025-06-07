extends GrabRigidBody
@onready var door: GrabRigidBody = $Door
var _grabbed = false;
var door_locked = true;
@onready var lock_joint: PinJoint3D = $LockJoint
@onready var plug: GrabRigidBody = $Plug
@onready var lights: OmniLight3D = $OmniLight3D

func _ready() -> void:
	door.on_grab.connect(_handle_door_grab)
	door.on_release.connect(_handle_door_release)
	
func _handle_door_grab():
	if(_grabbed): return
	body.freeze = true;
	door_locked = false;

func _handle_door_release():
	if(_grabbed): return
	body.freeze = false;
	
func grab():
	super.grab();
	_grabbed = true;
	door.grab();
	
func release():
	super.release();
	_grabbed = false;
	door.release();

func _physics_process(delta: float) -> void:
	#print(floor(rad_to_deg(door.rotation.y)))
	var door_rotation = floor(rad_to_deg(door.rotation.y));
	if(door_rotation > -2 && door_rotation < 20 && !body.freeze):
		door_locked = true;
	if(door_locked):
		door.body.collision_layer = 0
		door.body.collision_mask = 0
		lock_joint.node_a = body.get_path();
		lock_joint.node_b = door.get_path();
	else:
		if(!body.freeze):
			door.body.collision_layer = body.collision_layer
			door.body.collision_mask = body.collision_mask
		lock_joint.node_a = "";
		lock_joint.node_b = "";
	
	if not door_locked and door_rotation < -3 or door_rotation > 10:
		lights.visible = true;
	else:
		lights.visible = false;
	#print(_prev_colision_layer)
