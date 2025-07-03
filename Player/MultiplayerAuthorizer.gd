extends Node

@onready var state_machine: StateMachine = $"../StateMachine"
@onready var player: Player = $".."

var is_authorized: bool = true:
	get:
		return is_authorized
	set(value):
		if value != is_authorized:
			is_authorized = value;
			authorized_changed.emit(value);

signal authorized_changed(value: bool)

func _ready() -> void:
	player.set_multiplayer_authority(int(player.name))
	
	if not multiplayer.has_multiplayer_peer():
		is_authorized = true
	elif not is_multiplayer_authority():
		is_authorized = false;
