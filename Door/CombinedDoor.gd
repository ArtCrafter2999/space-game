extends Node
class_name CombinedDoor

@export var parts: Array[Door]

var is_open: bool:
	get:
		return parts[0].is_open;
var is_closed: bool:
	get:
		return parts[0].is_closed;

func open():
	for part in parts:
		part.open();
func close():
	for part in parts:
		part.close();
func switch():
	for part in parts:
		part.switch(); 
