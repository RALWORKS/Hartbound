extends "res://abstract/cutscene/CutsceneNode.gd"

func _on_show():
	#$"/root/Game".save_position()
	$"/root/Game".save()
	await get_tree().create_timer(0.4).timeout
	$"../Saved".start()
	$".".leave()

func start():
	_on_show()
	super.start()
