extends Node

@export var data = {}
@export var categories = {}
@onready var stemmer = $Stemmer

var _index = {}

const RECORD_MARKER = "_"
const WEIGHT_MARKER = "$"

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
	categories[$Quest.category] = categories[$Quest.category].filter(
		func (c): return c not in to_rm
	)
	for c in to_rm:
		data.erase(c.id)
		$Quest.remove_child(c)
		c.call_deferred("free")

func search(phrase, ix=null):
	if ix == null:
		ix = _index

	var tokens = _get_token_stems(phrase)
	var match_objects = _get_match_objects(tokens, 0, ix)

	match_objects.sort_custom(_sort_match_objects)
	match_objects = _filter_match_0_scores_if_needed(match_objects)
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

func _filter_match_0_scores_if_needed(sorted_match_objects):
	if sorted_match_objects.size() < 1:
		return sorted_match_objects
	if sorted_match_objects[0][1] == 0:
		return sorted_match_objects

	var new_match_objects = []
	for match_object in sorted_match_objects:
		if match_object[1] > 0:
			new_match_objects.push_back(match_object)
	return new_match_objects
	

func _get_match_objects(remaining_tokens, depth, sub_index):
	var new_match_objects = []
	
	var i = 0

	for token in remaining_tokens:
		if i == remaining_tokens.size() - 1: #and token.length() > 2:
			for possibility in sub_index:
				if possibility.find(token) == 0:
					new_match_objects.push_back([
							sub_index[possibility][RECORD_MARKER],
							depth + sub_index[possibility][WEIGHT_MARKER],
					])
		elif token in sub_index:
			new_match_objects.push_back([
				sub_index[token][RECORD_MARKER],
				depth + sub_index[token][WEIGHT_MARKER]
			])
			if remaining_tokens.size() - i > 1:
				new_match_objects += _get_match_objects(
					remaining_tokens.slice(i + 1),
					depth,
					sub_index[token],
				)
		i += 1

	return new_match_objects
	

func index():
	var tmp = {}
	for category in get_children().filter(func (c): return c not in [
		$Quest,
		$Stemmer
	]):
		for concept in category.get_children():
			tmp = index_concept(tmp, concept)
	
	_index = tmp

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
		var weight = 1
		if token in $Stemmer.half_stop_words:
			weight = 0
		
		if not token in sub_index:
			sub_index[token] = {}
			sub_index[token][RECORD_MARKER] = []
			sub_index[token][WEIGHT_MARKER] = weight

		if concept not in sub_index[token][RECORD_MARKER]:
			sub_index[token][RECORD_MARKER].push_back(concept)
		
		if remaining_tokens.size() - i > 1:
			sub_index[token] = _write_concept_to_index_by_tokens(
				concept, sub_index[token], remaining_tokens.slice(i+1)
			)
		i += 1
	return sub_index
	
	
func _populate_custom_index_dict(sub_dict_orig, sub_dict_new, npc_name):
	for old_key in sub_dict_orig:
		if old_key == WEIGHT_MARKER:
			sub_dict_new[WEIGHT_MARKER] = sub_dict_orig[WEIGHT_MARKER]
			continue
		if old_key == "_" and "_" in sub_dict_new:
			sub_dict_new["_"] += sub_dict_orig["_"].duplicate()
		elif old_key == "_":
			sub_dict_new["_"] = sub_dict_orig["_"].duplicate()
		else:
			var new_key = old_key.replace("npc", npc_name)
			var next_sub = {}
			if new_key in sub_dict_new:
				next_sub = sub_dict_new[new_key]
			sub_dict_new[new_key] = _populate_custom_index_dict(
				sub_dict_orig[old_key], next_sub, npc_name
			)
	return sub_dict_new

func make_custom_npc_index(npc_name):
	return _populate_custom_index_dict(_index, {}, npc_name)
