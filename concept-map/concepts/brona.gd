"""
Always explicitely inherit these--you need to redefine the id
"""

extends Node

static var id = "brona"

static func get_or_create(game: Node):
	var concept_map = game.get_node("ConceptMap")
	var instance = concept_map.get_concept(id)
	if instance != null:
		return instance
	instance = new()
	concept_map.add_concept(instance)
	return instance

# Called when the node enters the scene tree for the first time.
func _ready():
	assert(id.length() > 0)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
