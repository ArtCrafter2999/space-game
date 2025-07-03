extends Node3D
class_name StateMachine

@export var begining_state: StateBase
var state: StateBase = null;

func _ready() -> void:
	var states = find_children("*", "StateBase", true, false) as Array[StateBase]
	for state in states:
		state.machine = self
	child_entered_tree.connect(on_child_entered_tree)
	if begining_state:
		change_state(begining_state)

func on_child_entered_tree(node: Node):
	if "machine" in node:
		node.machine = self;

func _input(event: InputEvent) -> void:
	if not state: return
	state.input(event);

func _process(delta: float) -> void:
	if not state: return
	state.process(delta);
	
func _physics_process(delta: float) -> void:
	if not state: return
	state.physics_process(delta)

func change_state(new_state: StateBase):
	if state == new_state and not state.can_reenter:
		return;
	if state:
		await state.exit();
	state = new_state
	state.safe_enter(self);
