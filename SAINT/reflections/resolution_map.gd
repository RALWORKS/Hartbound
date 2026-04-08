extends Node

var data = {}

# Called when the node enters the scene tree for the first time.
func _ready():
	for item in get_children():
		data[item.id] = item
