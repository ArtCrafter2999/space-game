extends AudioStreamPlayer3D

@export var gravity_listener: GravityListener
@onready var tween : Tween
var beginig_volume;
var begining_max_distance;
var in_space := false

func _ready() -> void:
	beginig_volume = volume_db
	begining_max_distance = max_distance

func _process(delta: float) -> void: # TODO: change when adding air
	if gravity_listener.gravity_limit and not in_space:
		in_space = true;
		if tween:
			tween.kill()
		tween = create_tween()
		tween.tween_property(self, "volume_db", -40, 0.2)
		tween.tween_property(self, "max_distance", 1, 0.2)
		await tween.finished
		bus = "Space";
	elif gravity_listener.gravity_limit and in_space:
		in_space = false;
		bus = "Air";
		if tween:
			tween.kill()
		tween = create_tween()
		tween.tween_property(self, "volume_db", beginig_volume, 0.2)
		tween.tween_property(self, "max_distance", begining_max_distance, 0.2)
