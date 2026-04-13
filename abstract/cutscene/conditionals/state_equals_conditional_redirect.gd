extends Node

func condition(state_path, predicate):
	var data = $"/root/Game".get_state(state_path.split(","))
	return data == predicate
