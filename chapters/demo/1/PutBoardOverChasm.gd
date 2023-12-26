extends Node

@export var event_name: String

func action(e):
	var item = e.get_parent()
	item.unlock()
