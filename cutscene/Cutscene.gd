extends Node2D

@export var starting_page: CutsceneNode
@export var concepts: Node
@export var default_topics: Node
@export var next_cutscene: Resource
@export var cutscene_sequence: Array[Resource] = []
var page = null
@export var npc: CharacterBody2D = null # will auto set if used as npc dialogue
@export var npc_name = ""

var scene_bg = null
var input_data = null

var characters_present = []

@export var main_concepts_page: CutsceneNode

# Called when the node enters the scene tree for the first time.
func _ready():
	hide_children(self)
	if concepts:
		for item in concepts.get_children():
			hide_children(item)
	if default_topics:
		hide_children(default_topics)
#	start()

func hide_children(p):
	for sub in p.get_children():
		if sub.has_method("hide"):
			sub.visible = false


func update_page(p):
	page = p

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func start():
	print(characters_present)
	if starting_page:
		starting_page.start()

func talk_about_default_topic(concept):
	var topics = default_topics.get_children()
	var defaults = topics.filter(func(t): return t.tag == concept.get_parent().category)
	page.leave()
	if defaults:
		defaults[0].start()
		return
	topics[0].start()

func talk_about(concept):
	if concepts == null:
		return
	var nodes = concepts.get_children().filter(func(c): return c.id == concept.id)
	if nodes.size() == 0:
		talk_about_default_topic(concept)
		return
	page.leave()
	var pages = nodes[0].get_children().filter(_filter_not_tag)
	pages[0].start()
	if not pages[-1].end and main_concepts_page:
		pages[-1].next = main_concepts_page
	
	

func _filter_not_tag(a):
	return not "is_tag" in a or not a.is_tag
