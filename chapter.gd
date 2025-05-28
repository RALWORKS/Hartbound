extends Node
class_name Chapter


@export var starting_scene: Resource
@export var starting_music: AudioStreamPlayer
@export var script_holder: Node

@export var map: Resource
var active_map = null

var events_done = []
var map_events_done = []

var scene0 = null

var cur_game: Array[Node]

var cutscene

var cached_scene_path
var cached_bg_scale
var cached_bg_position

var game = null


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


func get_next_map_event():
	for c in $MapEvents.get_children():
		if not c.played:
			return c
	return null


func rerun_all_events():
	for ix in events_done:
		var event = $Events.get_children()[ix]
		event.rerun()
	for ix in map_events_done:
		var event = $MapEvents.get_children()[ix]
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
	events_done = game.get_state(["micro_progress", "events"])
	map_events_done = game.get_state(["micro_progress", "map_events"])
	if no_events(events_done):
		game.set_state(["micro_progress", "events"], [])
		events_done = []
	if no_events(map_events_done):
		game.set_state(["micro_progress", "map_events"], [])
		map_events_done = []

func no_events(data):
	if data == null or data.size() == 0:
		return true

func _default_init():
	scene0 = starting_scene.instantiate()
	game.show_clock = true
	#scene0.spawn_at = "n"
	#$"../MainScreen/World".add_child(scene0)
	$"../Map".start(scene0, self)
	reload_events_done()
	print("init", events_done)
	scene0.spawn($"..")

# Called when the node enters the scene tree for the first time.
func _ready():
	game = $".".get_tree().get_root().get_node("Game")
	if script_holder != null and script_holder.has_method("pre_init"):
		script_holder.pre_init()
	_default_init()
	if starting_music != null:
		game.play_music(starting_music)
	if events_done.size() == 0:
		game.save_room(scene0.scene_file_path)
		game.save_position()
		call_deferred("next")
	else:
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
	cutscene.characters_present = game.characters_present.duplicate()
	
	var world = $"../MainScreen/World".get_children()
	var bg
	
	game.save_position()
	
	if world.size() > 0:
		var scene: Node2D = $"../MainScreen/World".get_children()[0]
		if "dialogue_bg_scale" in scene:
			bg = scene.scene_file_path
			cached_scene_path = bg#.texture
			cached_bg_scale = scene.dialogue_bg_scale
			cached_bg_position = scene.dialogue_bg_position
		#cur_game = world

		for child in world:
			#$"../MainScreen/World".call_deferred("remove_child", child)
			child.queue_free()
	
	$"../MainScreen/World".call_deferred("add_child", cutscene)
	cutscene.npc = npc
	# cutscene.scene_bg = bg
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
		#n.free()
		#holdouts.push_back(n)
		
	print("ROUNDUP SCHEME DONE -- actually")

	cutscene.queue_free()
	cutscene = null
	#await get_tree().create_timer(0.1).timeout
	print("ALL FREE")
#	#game.free_world()
	game.chapter = self
	if next_chapter != "":
		$"/root/Game".to_chapter(next_chapter)
		return
	if next_cutscene != null:
		#await get_tree().create_timer(0.1).timeout
		print("start next", next_cutscene)
		start_cutscene(next_cutscene, npc, null, sequence)
		return
	
	game.show_clock = true

	reload_world()

	#await get_tree().create_timer(0.1).timeout
	if is_move:
		$"/root/Game".move()

	if teleport_to != null:
		$"/root/Game/Map".move_to(teleport_to)
		teleport_to.spawn(game)
		$"/root/Game".save_room(teleport_to.scene_file_path, null)
	if notification:
		game.notify(notification)

func update_cutscene_page(p):
	cutscene.update_page(p)

func to_map():
	if not map or active_map:
		return
	
	active_map = map.instantiate()
	active_map.chapter = self
	
	var world = $"../MainScreen/World".get_children()
	#var bg
	
	for child in world:
		child.queue_free()
	
	$"../MainScreen/World".call_deferred("add_child", active_map)
	active_map.load_position($"/root/Game")

func _clean_up_map():
	active_map.call_deferred("free")
	await get_tree().create_timer(0.05).timeout
	#$"/root/Game".move()
	active_map = null
	game.show_clock = true

func close_map(biome):
	_clean_up_map()
	
	if not biome:
		game.load_position()
		return
	
	if biome.trigger_name:
		return trigger(biome.trigger_name)
	
	var event = get_next_map_event()
	
	if not event:
		return
	
	event.cutscene_input_data = biome
	event.play()

func close_map_to_encounter(encounter):
	_clean_up_map()
	
	var event = get_next_map_event()
	
	if not event:
		return
	
	event.cutscene_input_data = encounter
	event.play()

func get_character_dialogue(id):
	var data = null
	for c in $CharacterCutscenes.get_children():
		if c.id == id:
			data = c
			break
	return data.dialogue


func reload_world(free=false):
	game.reload()
	#for child in cur_game:
	#	if is_instance_valid(child):
	#		if free:
	#			child.free()
	#		else:
	#			$"../MainScreen/World".add_child(child)


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
