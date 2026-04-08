extends Node

func condition(subject, _predicate):
	return $"/root/Game".has_resolution(subject)
