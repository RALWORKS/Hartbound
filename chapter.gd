extends Node
@export var starting_scene: Resource
@export var starting_music: AudioStreamPlayer
@export var script_holder: Node

var events_done = []

var scene0 = null

var cur_game: Array[Node]

var cutscene

var game = null

func trigger(trigger_name, e=null):
	var t = $Triggers.get_node(trigger_name)
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

func start_cutscene(cutscene_res, npc=null):
	cutscene = cutscene_res.instantiate()
	cutscene.characters_present = game.characters_present.duplicate()

	cur_game = $"../MainScreen/World".get_children()
	for child in $"../MainScreen/World".get_children():
		$"../MainScreen/World".call_deferred("remove_child", child)
	
	$"../MainScreen/World".call_deferred("add_child", cutscene)
	cutscene.npc = npc
	cutscene.call_deferred("start")

func end_cutscene():
	var next_cutscene = cutscene.next_cutscene
	var npc = cutscene.npc
	cutscene.call_deferred("free")
	for child in cur_game:
		if is_instance_valid(child):
			$"../MainScreen/World".add_child(child)
	game.chapter = self
	if next_cutscene != null:
		await get_tree().create_timer(0.2).timeout
		start_cutscene(next_cutscene, npc)

func update_cutscene_page(p):
	cutscene.update_page(p)
