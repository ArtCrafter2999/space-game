extends Interactable

signal on_click

@rpc("any_peer", "call_local")
func interact():
	on_click.emit();
	if not multiplayer.is_server():
		interact.rpc_id(1)
