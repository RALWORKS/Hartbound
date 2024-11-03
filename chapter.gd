extends Node
@export var starting_scene: Resource
@export var starting_music: AudioStreamPlayer
@export var script_holder: Node

@export var map: Resource
var active_map = null

var events_done = []

var scene0 = null

var cur_game: Array[Node]

var cutscene

var cached_scene_bg

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
	if events_done == null:
		game.set_state(["micro_progress", "events"], [])
		events_done = []

func _default_init():
	scene0 = starting_scene.instantiate()
	#scene0.spawn_at = "n"
	#$"../MainScreen/World".add_child(scene0)
	$"../Map".start(scene0, self)
	reload_events_done()
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
	
	cutscene = cutscene_res.instantiate()
	cutscene.characters_present = game.characters_present.duplicate()
	
	var world = $"../MainScreen/World".get_children()
	var bg
	
	if world.size() > 0:
		bg = $"../MainScreen/World".get_children()[0].get_node_or_null("Background")
		if bg:
			cached_scene_bg = bg.texture
		cur_game = world
		for child in world:
			$"../MainScreen/World".call_deferred("remove_child", child)
	else:
		bg = cached_scene_bg
	
	$"../MainScreen/World".call_deferred("add_child", cutscene)
	cutscene.npc = npc
	cutscene.scene_bg = bg
	cutscene.input_data = input_data
	if cutscene_sequence.size() > 0:
		cutscene.next_cutscene = cutscene_sequence.pop_front()
		for c in cutscene_sequence:
			cutscene.cutscene_sequence.push_back(c)
	else:
		cutscene.next_cutscene = next_cutscene if next_cutscene else cutscene.next_cutscene
	cutscene.call_deferred("start")

func end_cutscene():
	var next_cutscene = cutscene.next_cutscene
	var npc = cutscene.npc
	var next_chapter = cutscene.to_chapter
	var sequence = cutscene.cutscene_sequence
	var teleport_to = cutscene.teleport_to

	cutscene.call_deferred("free")
	#game.free_world()
	game.chapter = self
	if next_chapter != "":
		$"/root/Game".to_chapter(next_chapter)
		return
	if next_cutscene == null:
		for child in cur_game:
			if is_instance_valid(child):
				$"../MainScreen/World".add_child(child)
		await get_tree().create_timer(0.1).timeout
		$"/root/Game".move()
		if teleport_to:
			$"/root/Game/Map".move_to(teleport_to)
		return
	await get_tree().create_timer(0.1).timeout
	start_cutscene(next_cutscene, npc, null, sequence)

func update_cutscene_page(p):
	cutscene.update_page(p)

func to_map():
	if not map:
		return
	
	active_map = map.instantiate()
	active_map.chapter = self
	
	var world = $"../MainScreen/World".get_children()
	var bg
	
	for child in world:
		$"../MainScreen/World".call_deferred("remove_child", child)
	
	$"../MainScreen/World".call_deferred("add_child", active_map)
	active_map.load_position()

func close_map(biome):
	active_map.call_deferred("free")
	for child in cur_game:
		if is_instance_valid(child):
			$"../MainScreen/World".add_child(child)
	await get_tree().create_timer(0.1).timeout
	$"/root/Game".move()
	
	var event = get_next_map_event()
	if not event:
		return
	
	event.cutscene_input_data = biome
	event.play()
