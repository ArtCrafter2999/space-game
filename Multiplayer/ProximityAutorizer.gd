@tool
extends Node3D
class_name ProximityAuthorizer

@export var authority_object: Node

func _process(delta: float) -> void:
	if Engine.is_editor_hint(): return
	authorize_to_nearest_player();

func authorize_to_nearest_player():
	if not authority_object: return;
	
	var players = get_tree().get_nodes_in_group("PlayerCharacter") as Array[Player]
	players.sort_custom(func(a: Player, b: Player):
		var dist_a = a.global_position.distance_squared_to(global_position)
		var dist_b = b.global_position.distance_squared_to(global_position)
		
		return dist_a < dist_b
	)

	var nearest = players[0]
	var playerId = int(nearest.name) # TODO Change to more reliable way of getting player ID
	if playerId != authority_object.get_multiplayer_authority():
		global_set_authority(playerId); 

@rpc("any_peer", "call_local")
func local_set_authority(playerId: int = multiplayer.get_unique_id()):
	if not authority_object: return;
	authority_object.set_multiplayer_authority(playerId)

func global_set_authority(playerId: int):
	local_set_authority.rpc(playerId)

func _enter_tree() -> void:
	if Engine.is_editor_hint():
		authority_object = get_parent();
