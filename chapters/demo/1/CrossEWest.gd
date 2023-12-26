extends Node

@export var event_name: String

func action():
	$"../..".next(event_name)
