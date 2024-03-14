extends Node

var data = {}

# Called when the node enters the scene tree for the first time.
func _ready():
	refresh()

func refresh():
	for item in get_children():
		data[item.id] = item

func get_data(id):
	return data[id]
