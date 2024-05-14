extends Node

func condition(subject:String, predicate:String):
	var g = $"/root/Game"
	
	return g.get_state(subject.split(",")) == g.get_state(predicate.split(","))
