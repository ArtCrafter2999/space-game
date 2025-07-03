extends RigidBody3D
class_name Player

@onready var multiplayer_synchronizer: MultiplayerSynchronizer = %"MultiplayerSynchronizer"
@onready var camera: Camera3D = %Camera

func _ready() -> void:
	multiplayer_synchronizer.set_multiplayer_authority(int(name))
	if multiplayer_synchronizer.is_multiplayer_authority():
		camera.current = true;
	else:
		collision_layer = 1;
		collision_mask = 7;
