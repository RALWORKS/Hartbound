extends Node

@onready var g: Game = get_tree().root.get_node_or_null("Game")


func null_or_empty(s):
	return s == null or s.is_empty()

pass # Replace with function body.
func not_null(item):
	if item == null:
		return false
	return true

func f_of(x: Node, f: String, args: Array = []):
	return x.callv(f, args)
	
