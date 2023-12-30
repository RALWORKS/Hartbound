extends Node

@export var node_to_remove: Node

func mutate():
	node_to_remove.free()

func rerun():
	mutate()
