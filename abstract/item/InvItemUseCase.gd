extends Node


@export var interaction_item_id: String
@export var destroy_self_on_use: bool = false
@export var on_use_source: Node


func use():
	on_use_source.on_use()
	if destroy_self_on_use:
		$".".get_parent().destroy()
