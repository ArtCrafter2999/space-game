extends Node

@onready var camera: Camera3D = %Camera
@onready var camera_back: Camera3D = %CameraBack
@onready var multiplayer_synchronizer: MultiplayerSynchronizer = %MultiplayerSynchronizer

func _unhandled_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("Change View"):
		if camera.current:
			camera_back.current = true
		elif camera_back.current:
			camera.current = true;
	
