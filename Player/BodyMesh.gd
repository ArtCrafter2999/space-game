extends MeshInstance3D

@onready var camera: Camera3D = %Camera
@onready var multiplayer_synchronizer: MultiplayerSynchronizer = %MultiplayerSynchronizer

func _process(delta: float) -> void:
	if multiplayer.has_multiplayer_peer() and multiplayer_synchronizer.is_multiplayer_authority() and camera.current:
		cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_SHADOWS_ONLY
	else:
		cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_ON
