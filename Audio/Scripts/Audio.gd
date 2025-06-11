extends AudioStreamPlayer3D

@export var gravity_listener: GravityListener
@onready var tween := create_tween()
var beginig_volume;
var begining_max_distance;
var in_space := false

func _ready() -> void:
	beginig_volume = volume_db
	begining_max_distance = max_distance

func _process(delta: float) -> void:
	var gravity = gravity_listener.calculate_gravity().length();
	if gravity < 0.1 and not in_space:
		in_space = true;
		tween.kill()  # Stop any existing tweens
		tween = create_tween()
		tween.tween_property(self, "volume_db", -40, 0.2)
		tween.tween_property(self, "max_distance", 1, 0.2)
		await tween.finished
		bus = "Space";
	elif gravity >= 0.1 and in_space:
		in_space = false;
		bus = "Air";
		tween.kill()  # Stop any existing tweens
		tween = create_tween()
		tween.tween_property(self, "volume_db", beginig_volume, 0.2)
		tween.tween_property(self, "max_distance", begining_max_distance, 0.2)
