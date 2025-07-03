extends Node

signal on_blur
signal on_focus

func _unhandled_input(event) -> void: 
	if not is_multiplayer_authority(): return;
	if Input.is_action_just_pressed("ui_cancel") and not Input.mouse_mode == Input.MOUSE_MODE_VISIBLE:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		on_blur.emit();
	elif event is InputEventMouseButton and not Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		on_focus.emit()
