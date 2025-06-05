extends Interactable

signal on_click

func interact():
	on_click.emit();
