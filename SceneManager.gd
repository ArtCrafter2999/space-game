extends Node3D

@export var player_scene: PackedScene;
@export var spawn_location: Node3D

func _ready() -> void:
	#var index = 0
	for id in GameManager.players:
		var player = player_scene.instantiate() as Node3D
		player.name = str(id)
		add_child(player);
		player.global_position = spawn_location.global_position;
