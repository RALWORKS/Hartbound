extends "res://cutscene/CutsceneNode.gd"


@export_multiline var section_id = ""
@export_multiline var prerequisite_id = ""
@export_multiline var disqualifier_id = ""
@export var else_go: CutsceneNode
@export var allow_repeats = false
@export var direct_to_next = false


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
		super.flip({"to": else_go, "force": true})
		return
	$"/root/Game".mark_cutscene_section_played(section_id)
	if direct_to_next:
		super.start()
		super.flip()
		return
	super.start()
	
