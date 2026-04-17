extends Node
class_name Chapter


@export var starting_scene: Resource
@export var starting_music: AudioStreamPlayer
@export var script_holder: Node

var pending_event = null

var events_done = []

var EVENTS_TO_LOAD = [
	["events_done", ["micro_progress", "events"]],
]

var scene0 = null

var cutscene

var cached_scene_path
var cached_bg_scale
var cached_bg_position


func trigger(trigger_name, e=null):
	var t = $Triggers.get_node(trigger_name)
	if t == null:
		return
	t.action(e)


func get_next_event():
	if $Events.get_child_count() == 0:
		return null
	if events_done.size() == 0:
		return $Events.get_children()[0]
	if events_done[-1] >= $Events.get_child_count() - 1:
		return null
	return $Events.get_children()[events_done[-1] + 1]


func rerun_all_events():
	if events_done.size() == 0:
		glob.g.save_room(scene0.scene_file_path)
		glob.g.save_position()
		call_deferred("next")

	for ix in events_done:
		var event = $Events.get_children()[ix]
		event.rerun()

func next(to_event_name=null):
	var event
	if to_event_name != null:
		event = $Events.get_node_or_null(to_event_name)
	else:
		event = get_next_event()
	if not event or event.played:
		return
	event.play()
	reload_events_done()
	
func reload_events_done():
	var done = []
	var key = null
	for row in EVENTS_TO_LOAD:
		key = row[1]
		self[row[0]] = glob.g.get_state(key)
		print(row[0], key, glob.g.get_state(key))
		if no_events(self[row[0]]):
			glob.g.set_state(key, [])
			self[row[0]] = []

func no_events(data):
	if data == null or data.size() == 0:
		return true

func _default_init():
	scene0 = starting_scene.instantiate()
	glob.g.show_clock = true
	if glob.g.get_travel()["is_active"]:
		reload_events_done()
		return
	loc.map.start(scene0, self)
	reload_events_done()
	scene0.spawn($"..")

# Called when the node enters the scene tree for the first time.
func _ready():
	if script_holder != null and script_holder.has_method("pre_init"):
		script_holder.pre_init()
	_default_init()
	if starting_music != null:
		glob.g.play_music(starting_music)
	rerun_all_events()

func _process(_delta):
	pass

func start_cutscene(
	cutscene_res,
	npc=null,
	next_cutscene=null,
	cutscene_sequence:Array=[],
	input_data=null
):
	if cutscene != null:
		cutscene.next_cutscene = cutscene_res
		return
	cutscene = cutscene_res.instantiate()
	cutscene.characters_present = glob.g.characters_present.duplicate()
	
	var world = glob.g.get_world().get_children()
	var bg
	
	glob.g.save_position()
	
	if world.size() > 0:
		var scene: Node2D = glob.g.get_world().get_children()[0]
		if "dialogue_bg_scale" in scene:
			bg = scene.scene_file_path
			cached_scene_path = bg
			cached_bg_scale = scene.dialogue_bg_scale
			cached_bg_position = scene.dialogue_bg_position

		for child in world:
			child.queue_free()
	
	glob.get_world().call_deferred("add_child", cutscene)
	cutscene.npc = npc
	cutscene.input_data = input_data
	if cutscene_sequence.size() > 0:
		cutscene.next_cutscene = cutscene_sequence.pop_front()
		for c in cutscene_sequence:
			cutscene.cutscene_sequence.push_back(c)
	else:
		cutscene.next_cutscene = next_cutscene if next_cutscene else cutscene.next_cutscene
	cutscene.call_deferred("start")
	print("SC ", cutscene, cutscene.get_parent)

func end_cutscene(free=false):
	print("ENDSCENE INNER")
	var next_cutscene = cutscene.next_cutscene
	var npc = cutscene.npc
	var next_chapter = cutscene.to_chapter
	var sequence = cutscene.cutscene_sequence
	var teleport_to = cutscene.teleport_to
	var is_move = cutscene.is_move
	var notification = cutscene.closing_notification
	print("ENDSCENE VARS SET")
	
	var holdouts = []
	
	for n in cutscene.free_us_first:
		#n.get_parent().remove_child(n)
		n.pre_free()

	cutscene.queue_free()
	
	cutscene = null
	glob.g.chapter = self
	if next_chapter != "":
		glob.g.to_chapter(next_chapter)
		return
	if next_cutscene != null:
		start_cutscene(next_cutscene, npc, null, sequence)
		return
	
	if pending_event != null:
		var c = pending_event.cutscene
		handle_pending_event()
		if c != null:
			return
	glob.g.show_clock = true

	reload_world()

	#await get_tree().create_timer(0.1).timeout
	if is_move:
		glob.g.move()

	if teleport_to != null:
		teleport(teleport_to)
	if notification:
		glob.g.notify(notification)

func teleport(teleport_to):
	loc.map.move_to(teleport_to)
	teleport_to.spawn(glob.g)
	glob.g.save_room(teleport_to.scene_file_path, null)

func handle_pending_event():
	if pending_event != null:
		pending_event.play()

func update_cutscene_page(p):
	cutscene.update_page(p)
	
func get_resource_by_index(bank, ix):
	if ix == null:
		return null
	if ix < bank.size():
		return bank[ix]
	return null




func get_resource_index(bank, path):
	var i = 0
	while i < bank.size():
		var d: Resource = bank[i]
		if d.resource_path == path:
			return i
		i = i + 1
	return null


func get_character_dialogue(id):
	var data = null
	for c in $CharacterCutscenes.get_children():
		if c.id == id:
			data = c
			break
	if not data:
		return
	return data.dialogue


func reload_world(free=false):
	glob.g.reload()


func get_dialogue_by_id(id):
	var cuts = $CharacterCutscenes.get_children()
	for c in cuts:
		if c.id == id:
			return c.dialogue
	return null


func feed(type, data):
	var event = get_next_event()
	if not event:
		return
	event.receive_action(type, data)
