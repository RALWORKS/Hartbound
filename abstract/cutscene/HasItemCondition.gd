extends Node

func condition(subject, _predicate):
	return $"/root/Game".inventory_contains(subject)
