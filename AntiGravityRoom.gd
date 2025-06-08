extends Node3D

@onready var anti_gravity: GravitySwitcher = $AntiGravity
@onready var combined_door_1: CombinedDoor = $CombinedDoor
@onready var combined_door_2: CombinedDoor = $CombinedDoor2
@onready var air_left: Timer = $AirLeft

func switch_gravity_room():
	combined_door_2.switch();
	print(combined_door_2.is_closed)
	if(combined_door_2.is_closed):
		anti_gravity.switch();
		air_left.start()
		await air_left.timeout;
		anti_gravity.switch();
