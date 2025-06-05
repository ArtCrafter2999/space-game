extends Node3D

@onready var anti_gravity: GravitySwitcher = $AntiGravityRoom/AntiGravity
@onready var combined_door_1: CombinedDoor = $AntiGravityRoom/CombinedDoor
@onready var combined_door_2: CombinedDoor = $AntiGravityRoom/CombinedDoor2
@onready var ship_gravity: GravityBroadcast = $Plane/ShipGravity
@onready var air_left: Timer = $AntiGravityRoom/AirLeft

func switch_gravity_room():
	combined_door_2.switch();
	print(combined_door_2.is_closed)
	if(combined_door_2.is_closed):
		anti_gravity.switch();
		air_left.start()
		await air_left.timeout;
		anti_gravity.switch();
