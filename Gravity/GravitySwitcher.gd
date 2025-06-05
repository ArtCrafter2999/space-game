extends GravityBroadcast
class_name GravitySwitcher

@export var collision_shape_3d: CollisionShape3D
func _ready() -> void:
	super._ready();
	if(!collision_shape_3d):
		for child in get_children():
			if(child is CollisionShape3D):
				collision_shape_3d = child;
				break;
	if(!collision_shape_3d):
		push_error("Collision shape is not set");

func apply_gravity():
	collision_shape_3d.disabled = true;
	pass
func apply_antigravity():
	collision_shape_3d.disabled = false;
func switch():
	collision_shape_3d.disabled = !collision_shape_3d.disabled;
