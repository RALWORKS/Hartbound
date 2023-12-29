extends Node2D

var game = null

# Called when the node enters the scene tree for the first time.
func _ready():
	game = $"/root".get_node_or_null("Game")
	refresh_data($CharacterRecord)

func refresh_data(character_record=null):
	if not character_record:
		character_record = $CharacterRecord
	if not game:
		return
	var name_ = game.get_state(["character", "name"])
	if not name_:
		return
	$ProfileBtn/Label.text = name_["short"]
	var full_name = character_record.get_node("FullName")
	full_name.clear()
	var short_name = name_["elf_short"]
	if name_["elves_call"] == name_["humans_call"]:
		short_name = name_["short"]
	else:
		name_["elf_short"] += "/" + name_["human_short"]
	full_name.add_text(name_["full"] + "  (%s)" % short_name)
	var full_name_def = character_record.get_node("FullNameDefinition")
	full_name_def.clear()
	full_name_def.append_text("[i]" + name_["full_def"] + "[/i]")
	
	var full_story = character_record.get_node("Story")
	full_story.clear()
	var story = game.get_state(["story"])
	for item in story:
		full_story.append_text(
			#"-  "
			item["narrative"]
			+ ("."	if item["narrative"][-1] not in [".", "!", "?"] else "")
			+ "\n"
		)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func _on_profile_btn_pressed():
	open_character_record()

func open_character_record():
	var c = $CharacterRecord.duplicate()
	refresh_data(c)
	c.visible = true
	c.open(game)

func close_character_record():
	$CharacterRecord.close()

func _on_character_record_close_requested():
	close_character_record()


func _on_character_record_focus_exited():
	close_character_record()
