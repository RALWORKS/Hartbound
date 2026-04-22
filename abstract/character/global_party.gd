extends Node

signal check_party

var party = []


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func get_followers():
	_init_party_if_needed()
	party = state.get_state(["party"])
	emit_signal("check_party")
	return party

func check_state_for_follower(npc):
	_init_party_if_needed()
	var followers = state.get_state(["party"])
	return followers.has(npc.id)

	
func _init_party_if_needed():
	var q = state.get_state(["party"])
	if q != null:
		return
	state.set_state(
		["party"],
		[],
	)
