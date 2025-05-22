extends Node2D

@export var to_chapter: String = ""
@export var show_clock = true
@export var is_move: bool = true
@export var starting_page: CutsceneNode
@export var concepts: Node
@export var default_topics: Node
@export var next_cutscene: Resource
@export var cutscene_sequence: Array[Resource] = []
var page = null
@export var npc: CharacterBody2D = null # will auto set if used as npc dialogue
@export var npc_name = ""
var npc_id = null

@export var free_us_first: Array[Node]

var teleport_to = null

# from a previous attempt to implement standard bg
# var scene_bg = null
var input_data = null

var characters_present = []

@export var main_concepts_page: CutsceneNode


func free_tricky_nodes():
	for n in free_us_first:
		n.free()

# Called when the node enters the scene tree for the first time.
func _ready():
	$"/root/Game".show_clock = show_clock
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
	if starting_page:
		starting_page.start()
	
	if npc != null:
		npc_id = npc.id
		var emitter = $"/root/Game".action_emitter
		emitter.send(emitter.TYPE.HI, {"npc_id": npc_id})

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
	if npc_id != null:
		var emitter = $"/root/Game".action_emitter
		emitter.send(emitter.TYPE.TOPIC, {"npc_id": npc_id, "concept_id": concept.id})
	page.leave()
	var pages = nodes[0].get_children().filter(_filter_not_tag)
	pages[0].start()
	
	for p in pages:
		if p.next == null and not p.end and main_concepts_page:
			p.next = main_concepts_page
	
	#if not pages[-1].end and main_concepts_page:
	#	pages[-1].next = main_concepts_page
	
	

func _filter_not_tag(a):
	return not "is_tag" in a or not a.is_tag
