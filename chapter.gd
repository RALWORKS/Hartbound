extends Node
@export var starting_scene: Resource
@export var starting_music: AudioStreamPlayer
@export var script_holder: Node

var sequence_ix = 0

var scene0 = null

var cur_game: Array[Node]

var cutscene

var game = null

func next(to_event_name=null):
	var event
	if to_event_name:
		event = $Events.get_node_or_null(to_event_name)
	else:
		event = $Events.get_child(sequence_ix)
	if not event:
		return
	event.play()
	sequence_ix = event.get_index()
	
func reload_sequence_ix():
	sequence_ix = game.get_state(["micro_progress", "event"])

func _default_init():
	scene0 = starting_scene.instantiate()
	#scene0.spawn_at = "n"
	#$"../MainScreen/World".add_child(scene0)
	$"../Map".start(scene0, self)
	reload_sequence_ix()
	scene0.spawn($"..")

# Called when the node enters the scene tree for the first time.
func _ready():
	game = $".".get_tree().get_root().get_node("Game")
	if script_holder != null and script_holder.has_method("pre_init"):
		script_holder.pre_init()
	_default_init()
	if starting_music != null:
		game.play_music(starting_music)
	if $Events.get_child_count() > 0 and sequence_ix == 0:
		next()

func _process(_delta):
	pass

func start_cutscene(cutscene_res, npc=null):
	cutscene = cutscene_res.instantiate()
	cur_game = $"../MainScreen/World".get_children()
	for child in $"../MainScreen/World".get_children():
		$"../MainScreen/World".call_deferred("remove_child", child)
	
	$"../MainScreen/World".add_child(cutscene)
	cutscene.npc = npc
	cutscene.start()

func end_cutscene():
	cutscene.free()
	for child in cur_game:
		$"../MainScreen/World".add_child(child)

func update_cutscene_page(p):
	cutscene.update_page(p)
