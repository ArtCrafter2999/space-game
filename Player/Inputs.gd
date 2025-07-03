extends Node
class_name Inputs

@export var sensativity: float = 0.35

@onready var player_authorizer: Node = $"../PlayerAuthorizer"

var input_dir: Vector2 = Vector2.ZERO;
var sprint: bool = false;
var jump: bool:
	get:
		return disabled_reasons.is_empty() and Input.is_action_just_pressed("Jump");
var mouse: Vector2 = Vector2.ZERO;
var disabled_reasons: Array[String] = [];

func _ready() -> void:
	player_authorizer.authorized_changed.connect(func(value): setDisabled(not value, "authority"))

func _unhandled_input(event: InputEvent) -> void:
	if not disabled_reasons.is_empty():
		mouse = Vector2.ZERO;
		return;
		
	if event is InputEventMouseMotion:
		var motionEvent: InputEventMouseMotion = event
		mouse = Vector2(
			-motionEvent.relative.x * 0.01 * sensativity, 
			-motionEvent.relative.y * 0.01 * sensativity
		)

func _process(delta: float) -> void:
	if not disabled_reasons.is_empty():
		input_dir = Vector2.ZERO;
		sprint = false;
		jump = false;
		return;
	input_dir = Input.get_vector("Left", "Right", "Forward", "Backward")
	sprint = Input.is_action_pressed("Sprint")

func disable(reason := "default"):
	if not disabled_reasons.has(reason):
		disabled_reasons.append(reason);

func enable(reason := "default"):
	var index = disabled_reasons.find(reason)
	if index != -1:
		disabled_reasons.remove_at(index);

func setDisabled(value: bool, reason := "default"):
	if value and not disabled_reasons.has(reason):
		disable(reason)
	elif not value and disabled_reasons.has(reason):
		enable(reason)
