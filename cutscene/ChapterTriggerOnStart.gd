extends Node


@export var trigger_name: String

func on_start():
	$"/root/Game/Chapter".trigger(trigger_name)
