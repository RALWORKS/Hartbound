extends Node


func condition(specifier: String, _predicate):
	var characters = specifier.split(",")
	
	var present = $"/root/Game/Chapter".cutscene.characters_present
	
	for c in characters:
		if c in present:
			return true
	
	return false
