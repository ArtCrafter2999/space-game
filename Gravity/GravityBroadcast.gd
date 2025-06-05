extends Area3D
class_name GravityBroadcast

func _ready() -> void:
	area_entered.connect(handle_area_entered);
	area_exited.connect(handle_area_exited);
	
func _physics_process(delta: float) -> void:
	if(!gravity_point):
		gravity_direction = -global_basis.y
	
func handle_area_entered(area):
	if !(area is GravityListener): return;
	var listener = area as GravityListener;
	listener.gravity_areas.append(self);
	
func handle_area_exited(area):
	if !(area is GravityListener): return;
	var listener = area as GravityListener;
	listener.gravity_areas.erase(self);
