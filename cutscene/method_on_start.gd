extends Node

@export var subject: Node
@export var method: String
@export var arg: String
@export var delay_clickthrough: float

func on_start():
	get_parent().is_option_node = true
	subject.call(method, arg)
	await get_tree().create_timer(delay_clickthrough).timeout
	get_parent().is_option_node = false
