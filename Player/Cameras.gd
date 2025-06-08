extends Node3D

@onready var camera: Camera3D = %Camera
@onready var camera_back: Camera3D = $CameraBack

func _unhandled_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("Change View"):
		if camera.current:
			camera_back.current = true
		elif camera_back.current:
			camera.current = true;
	
