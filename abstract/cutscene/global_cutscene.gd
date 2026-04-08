extends Node


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _init_played_cutscenes_if_needed():
	var data = state.get_state(["played_cutscenes"])
	if data != null:
		return data
	return state.set_state(["played_cutscenes"], [])


func is_cutscene_section_already_played(section_id):
	var played = _init_played_cutscenes_if_needed()
	return section_id in played

func mark_cutscene_section_played(section_id):
	_init_played_cutscenes_if_needed()
	state.set_state_push_to_key(["played_cutscenes"], section_id)
