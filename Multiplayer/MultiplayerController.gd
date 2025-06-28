extends Control

#@export var address = "127.0.0.1"
@export var port = 8910
@onready var username_input: LineEdit = $UsernameInput
@onready var ip_input: LineEdit = $IpInput

func _ready() -> void:
	multiplayer.peer_connected.connect(player_connnected)
	multiplayer.peer_disconnected.connect(player_disconnnected)
	multiplayer.connected_to_server.connect(connected_to_server)
	multiplayer.connection_failed.connect(connection_failed)

# called on the server and clients when connects
func player_connnected(id):
	print("player connected " + str(id))
	pass;

# called on the server and clients when disconnects
func player_disconnnected(id):
	print("player disconnected " + str(id))
	pass;

# called only from clients
func connected_to_server():
	print("connected to server")
	send_player_information.rpc_id(1,
		username_input.text,
		multiplayer.get_unique_id()
	)
	pass;

# called only from clients
func connection_failed():
	print("connection failed")
	pass;

var peer: ENetMultiplayerPeer

@rpc("any_peer")
func send_player_information(name, id):
	if not GameManager.players.has(id):
		GameManager.players[id] = { "name": name, "id": id }
	if multiplayer.is_server():
		for playerId in GameManager.players:
			send_player_information.rpc(
				GameManager.players[playerId].name,
				playerId
			)

@rpc("any_peer", "call_local")
func start_game():
	var scene = (load("res://TestScene.tscn") as PackedScene).instantiate()
	get_tree().root.add_child(scene);
	hide();

func _on_host_button_down() -> void:
	peer = ENetMultiplayerPeer.new();
	var error = peer.create_server(port, 2);
	if error:
		print("cannot host: ", error)
		return;
	
	#peer.host.compress(ENetConnection.COMPRESS_RANGE_CODER)
	
	multiplayer.multiplayer_peer = peer;
	
	send_player_information(username_input.text, multiplayer.get_unique_id())
	
	print("waiting for player")


func _on_join_button_down() -> void:
	peer = ENetMultiplayerPeer.new();
	peer.create_client(ip_input.text, port);
	
	#peer.host.compress(ENetConnection.COMPRESS_RANGE_CODER);
	
	multiplayer.multiplayer_peer = peer;

func _on_start_game_button_down() -> void:
	start_game.rpc();
	pass # Replace with function body.
