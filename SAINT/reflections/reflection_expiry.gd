extends Node

# TODO make the dynamic "let's think" cutscene
#  TODO connect it all
# TODO manual test strategy

@onready var ReflectionExpiredCutscene = preload("res://reflections/reflection_expired_cutscene.tscn")

func _gather_reflections():
	return get_children()

func _generate_chained_cutscenes(reflections):
	# there is 1 dynamically generated cutscene followed by
	# the cutscenes of each reflection
	# then we chain them
	#
	var cutscenes = []
	cutscenes.push_back(ReflectionExpiredCutscene)
	for r in reflections:
		cutscenes.push_back(r.cutscene)
	return cutscenes


func _play_cutscenes(cutscenes: Array, reflections: Array):
	var chapter = $"/root/Game/Chapter" # TODO check path
	var first = cutscenes[0]
	var rest = cutscenes.slice(1)
	chapter.start_cutscene(first, null, null, rest, reflections)

func expire():
	var reflections = _gather_reflections()
	var cutscenes = _generate_chained_cutscenes(reflections)
	_play_cutscenes(cutscenes, reflections) # the chaining is done to the cutscene objects--no need to loop
	# unregister myself?


func mutate():
	expire()

func rerun():
	pass
