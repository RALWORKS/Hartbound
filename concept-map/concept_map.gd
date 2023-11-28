extends Node

@export var data = {}
@export var categories = {}

# Called when the node enters the scene tree for the first time.
func _ready():
	for category in get_children():
		for item in category.get_children():
			_register_concept(item, category)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func get_concept(id):
	if id not in data:
		return null
	return data[id]

func _register_concept(concept, category):
	data[concept.id] = concept
	if not category.category in categories:
		categories[category.category] = []
	categories[category.category].push_back(concept)

func add_concept(concept, category):
	var cat = get_children().filter(func (c): return c.category == category.category)[0]
	concept.get_parent().remove_child(concept)
	cat.add_child(concept)
	_register_concept(concept, category)

func remove_quest_concepts(concepts):
	var to_rm = $Quest.get_children().filter(
		func (concept): return concept.id in concepts.map(func (c): return c.id)
	)
	print(to_rm)
	categories[$Quest.category] = categories[$Quest.category].filter(
		func (c): return c not in to_rm
	)
	for c in to_rm:
		data.erase(c.id)
		$Quest.remove_child(c)
		c.call_deferred("free")
