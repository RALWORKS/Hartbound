extends "res://cutscene/CutsceneNode.gd"


@export_multiline var section_id = ""
@export_multiline var prerequisite_id = ""
@export_multiline var disqualifier_id = ""
@export var else_go: CutsceneNode
@export var allow_repeats = false


func check_should_play():
	if $"/root/Game".is_cutscene_section_already_played(section_id) and not allow_repeats:
		return false
	if (
		prerequisite_id.length() > 0
		and not $"/root/Game".is_cutscene_section_already_played(prerequisite_id)
	):
		return false
	if (
		disqualifier_id.length() > 0
		and $"/root/Game".is_cutscene_section_already_played(disqualifier_id)
	):
		return false
	return true

func start():
	if not check_should_play():
		var old_next = next
		next = else_go
		super.flip()
		next = old_next
		return
	$"/root/Game".mark_cutscene_section_played(section_id)
	super.start()
	
