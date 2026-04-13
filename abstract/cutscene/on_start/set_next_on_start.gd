extends Node
@export var cutscene: Node = null
@export var next: Resource = null

func on_start():
	cutscene.next_cutscene = next
