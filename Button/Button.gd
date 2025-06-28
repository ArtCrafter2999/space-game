extends Interactable

signal on_click

func interact():
	_rpc_interact.rpc()

@rpc("any_peer", "call_local")
func _rpc_interact():
	on_click.emit();
