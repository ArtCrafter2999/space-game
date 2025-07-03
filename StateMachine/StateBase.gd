extends Node3D
class_name StateBase

@export var can_reenter: bool = false;

var machine: StateMachine;

func safe_enter(machine: StateMachine):
	if self.machine != machine:
		self.machine = machine;
	enter();
func input(event: InputEvent):
	pass
func enter():
	pass
func process(delta: float):
	pass
func physics_process(delta: float):
	pass
func exit():
	pass
