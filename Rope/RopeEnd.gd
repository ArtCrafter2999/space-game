extends Node3D
class_name RopeEnd
@export var joint: JoltJoint3D 
@export var body: PhysicsBody3D;

func _ready() -> void:
	if(!joint):
		if $PinJoint3D is Joint3D:
			joint = $PinJoint3D
		else:
			push_error("The joint property isn't defined")
	if(!body):
		var parent = get_parent();
		if(parent is PhysicsBody3D):
			body = parent
		else:
			push_error("The body property isn't defined")
			
	joint.node_a = body.get_path();

func connect_to(value: PhysicsBody3D):
	joint.node_b = value.get_path()
