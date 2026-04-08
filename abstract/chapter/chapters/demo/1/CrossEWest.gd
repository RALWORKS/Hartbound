extends Node

@export var event_name: String

func action(_e):
	$"../..".next(event_name)
