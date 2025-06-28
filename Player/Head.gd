extends Node3D

@onready var sub_neck: Node3D = $"../SubNeck"

func _process(delta: float) -> void:
	rotation = sub_neck.rotation
