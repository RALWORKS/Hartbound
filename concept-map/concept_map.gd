extends Node

@export var data = {}
@export var categories = {}
@onready var stemmer = $Stemmer

var _index = {}

const RECORD_MARKER = "_"

# Called when the node enters the scene tree for the first time.
func _ready():
	index()
	for category in get_children():
		if category == stemmer:
			continue
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
	var cat = get_children().filter(func (c): return "category" in c and c.category == category.category)[0]
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

func search(phrase):
	var tokens = _get_token_stems(phrase)
	var match_objects = _get_match_objects(tokens, 0, _index)
	match_objects.sort_custom(_sort_match_objects)
	return _deduped_concepts_from_match_objects(match_objects)
	
func _deduped_concepts_from_match_objects(match_objects):
	var ret = []
	for m in match_objects:
		for c in m[0]:
			if not c in ret:
				ret.push_back(c)
	return ret

func _sort_match_objects(a, b):
	return a[1] > b[1]	
	

func _get_match_objects(remaining_tokens, depth, sub_index):
	var new_match_objects = []
	
	var i = 0

	for token in remaining_tokens:
		if i == remaining_tokens.size() - 1 and token.length() > 2:
			for possibility in sub_index:
				if possibility.find(token) == 0:
					new_match_objects.push_back([sub_index[possibility][RECORD_MARKER], depth])
		elif token in sub_index:
			new_match_objects.push_back([sub_index[token][RECORD_MARKER], depth])
			if remaining_tokens.size() - i > 1:
				new_match_objects += _get_match_objects(
					remaining_tokens.slice(i + 1), depth + 1, sub_index[token]
				)
		i += 1

	return new_match_objects
	

func index():
	var tmp = {}
	for concept in (
		$People.get_children()
		+ $Things.get_children()
		+ $World.get_children()
	):
		tmp = index_concept(tmp, concept)
	
	_index = tmp
	print(_index)

func index_concept(ix, concept):
	var tags = concept.get_children()
	
	for tag in tags:
		var tokens = _get_token_stems(tag.phrase)
		ix = _write_concept_to_index_by_tokens(concept, ix, tokens)
	
	return ix

func _get_token_stems(phrase):
	return stemmer.get_stemmed_tokens(phrase)

func _write_concept_to_index_by_tokens(concept, sub_index, remaining_tokens):
	var i = 0
	while i < remaining_tokens.size():
		var token = remaining_tokens[i]
		
		if not token in sub_index:
			sub_index[token] = {}
			sub_index[token][RECORD_MARKER] = []

		if concept not in sub_index[token][RECORD_MARKER]:
			sub_index[token][RECORD_MARKER].push_back(concept)
		
		if remaining_tokens.size() - i > 1:
			sub_index[token] = _write_concept_to_index_by_tokens(
				concept, sub_index[token], remaining_tokens.slice(i+1)
			)
		i += 1
	return sub_index
