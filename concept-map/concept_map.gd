extends Node

@export var data = {}
@export var categories = {}

# Called when the node enters the scene tree for the first time.
func _ready():
	for category in get_children():
		for item in category.get_children():
			add_concept(item, category)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func get_concept(id):
	if id not in data:
		return null
	return data[id]

func add_concept(concept, category):
	data[concept.id] = concept
	if not category.category in categories:
		categories[category.category] = []
	categories[category.category].push_back(concept)
