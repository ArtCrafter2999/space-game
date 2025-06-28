extends Node3D

@export var player_scene: PackedScene;
@onready var spawn_location: Marker3D = $SpawnLocation

func _ready() -> void:
	#var index = 0
	for id in GameManager.players:
		var player = player_scene.instantiate() as Node3D
		player.name = str(id)
		add_child(player);
		player.global_position = spawn_location.global_position;
