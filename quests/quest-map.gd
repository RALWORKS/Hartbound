extends Node

@export var data = []
@export var categories = {}

# Called when the node enters the scene tree for the first time.
func _ready():
	for item in get_children():
		add_quest(item)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func get_quest(id):
	if id not in data:
		return null
	return data[id]

func add_quest(quest):
	data.push_back(quest.id)
