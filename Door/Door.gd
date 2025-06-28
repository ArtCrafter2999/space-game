extends Node3D
class_name Door
@onready var body: AnimatableBody3D = $"./DoorBody"
@onready var close_point: Marker3D = $"./ClosedPoint"
@onready var open_point: Marker3D = $"./OppenedPoint"

@export var speed: float = 1;

var is_open: bool:
	get: 
		return body.position == open_point.position
var is_closed: bool:
	get: 
		return body.position == close_point.position

@export var _open = false;
func switch():
	_open = !_open;
@rpc("any_peer", "call_local")
func open():
	_open = true;
func close():
	_open = false;
	
func _physics_process(delta: float) -> void:
	body.position = body.position.move_toward(
		(open_point if _open else close_point).position,
		 delta * speed
	);
