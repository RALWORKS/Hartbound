extends Node2D

var game = null

# Called when the node enters the scene tree for the first time.
func _ready():
	game = $"/root".get_node_or_null("Game")
	refresh_data($CharacterRecord)

func refresh_data(character_record):
	if not game:
		return
	var name_ = game.get_state(["character", "name"])
	if not name_:
		return
	$ProfileBtn/Label.text = name_["short"]
	var full_name = character_record.get_node("FullName")
	full_name.clear()
	full_name.add_text(name_["full"])
	var full_name_def = character_record.get_node("FullNameDefinition")
	full_name_def.clear()
	full_name_def.append_text("[i]" + name_["full_def"] + "[/i]")
	
	var full_story = character_record.get_node("Story")
	full_story.clear()
	var story = game.get_state(["story"])
	for item in story:
		full_story.append_text("-  " + item["narrative"] + "\n")

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
