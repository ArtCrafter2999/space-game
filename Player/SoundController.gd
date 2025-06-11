extends Node

@export var gravity_listener: GravityListener
@export var effects: Array[Dictionary]
@onready var tween := create_tween()
var in_space = false;
var fade := 0.0;

func _process(delta: float) -> void:
	var gravity = gravity_listener.calculate_gravity().length()
	var air_index = AudioServer.get_bus_index("Air");
	if gravity < 0.01 and not in_space:
		in_space = true;
		tween.kill()
		tween = create_tween();
		tween.tween_property(self, "fade", 1, 0.2)
			
	elif gravity >= 0.01 and in_space:
		in_space = false;
		tween.kill()
		tween = create_tween();
		tween.tween_property(self, "fade", 0, 0.2)
	
	AudioServer.set_bus_volume_db(air_index, fade * -40.0)
	for i in range(effects.size()):
		var from = (effects[i]["from"] as AudioEffect).duplicate()
		var bus_effect = AudioServer.get_bus_effect(air_index, i)
		if not bus_effect: 
			AudioServer.add_bus_effect(air_index, from, i)
			bus_effect = AudioServer.get_bus_effect(air_index, i)
		var to = effects[i]["to"] as AudioEffect
		var keys = effects[i]["keys"] as Array[String]
		
		for key in keys:
			bus_effect[key] = lerpf(from[key], to[key], fade)
	print(fade)
