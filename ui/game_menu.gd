extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	refresh_data()

func refresh_data():
	var game = $"/root".get_node_or_null("Game")
	if not game:
		return
	var name_ = game.get_state(["character", "name"])
	if not name_:
		return
	$ProfileBtn/Label.text = name_["short"]
	$CharacterRecord/FullName.clear()
	$CharacterRecord/FullName.add_text(name_["full"])
	$CharacterRecord/FullNameDefinition.clear()
	$CharacterRecord/FullNameDefinition.append_text("[i]" + name_["full_def"] + "[/i]")
	
	$CharacterRecord/Story.clear()
	var story = game.get_state(["story"])
	for item in story:
		$CharacterRecord/Story.append_text("-  " + item["narrative"] + "\n")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func _on_profile_btn_pressed():
	open_character_record()
	
func open_character_record():
	refresh_data()
	$CharacterRecord.visible = true
	$"../../World".set_disable_input(true)
	$CharacterRecord.grab_focus()

func close_character_record():
	$CharacterRecord.visible = false
	$"../../World".set_disable_input(false)

func _on_character_record_close_requested():
	close_character_record()


func _on_character_record_focus_exited():
	close_character_record()
