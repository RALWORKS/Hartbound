extends Node

var started = false
var paused = false
var unpausing = false
var is_scouting = false
var can_camp = false
var dying = false
var injured = false
var ritual: bool = false


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func handle_paused():
	if not started:
		pause()
		return true

	if glob.g.chapter != null and glob.g.chapter.cutscene != null:
		pause()
		return true

	if glob.g.cur_modal != null:
		pause()
		return true
	
	if glob.g.player == null:
		return true

	unpause()

	return false

func unpause():
	if unpausing:
		return
	unpausing = true
	await get_tree().create_timer(0.3).timeout
	if not unpausing:
		return
	paused = false

func pause():
	paused = true
	unpausing = false

func injure():
	state.set_state(["injured"], true)
	injured = true
	music.push_music($"../InjuryMusic")

func die():
	var cut = load("res://abstract/cutscene/you_died.tscn")
	glob.g.chapter.start_cutscene(cut)

func heal():
	glob.g.set_state(["injured"], false)
	injured = false
	music.pop_music($"../InjuryMusic")
