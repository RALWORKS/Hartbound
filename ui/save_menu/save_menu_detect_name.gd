extends "res://cutscene/CutsceneNode.gd"

# Called when the node enters the scene tree for the first time.
func _on_start():
	var cur_name = $"/root/Game".get_state(["savefile_name"])
	if cur_name and cur_name.length() > 0:
		$"../Saving".start()
		$".".leave()
	else:
		$"../NoSaveYet".start()
		$".".leave()

func start():
	super.start()
	_on_start()
