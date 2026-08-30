extends Node2D

var game = null

var SmartLabel = preload("res://abstract/cutscene/smart_label.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	game = $"/root".get_node_or_null("Game")
	glob.g.connect("player_mode_changed", player_mode_changed)
	#player_mode_changed(glob.g.player.mode)
	#refresh_data($CharacterRecord)

func player_mode_changed(new_mode):
	if new_mode == status.MODE.ELF:
		$HartboundIndicator.modulate = glob.WHITE
		$HartIndicator.modulate = glob.TRANSPARENT
		$PartySlot/RideButton.off()
	elif new_mode == status.MODE.ELK:
		$HartboundIndicator.modulate = glob.TRANSPARENT
		$HartIndicator.modulate = glob.WHITE
		$PartySlot/RideButton.off()
	else:
		$HartboundIndicator.modulate = glob.TRANSPARENT
		$HartIndicator.modulate = glob.TRANSPARENT
		$PartySlot/RideButton.on()

func refresh_data(character_record=null):
	#$ProfileBtn/Profile.refresh()
	#$CharacterRecord/black/Profile.refresh()
	#if not character_record:
	#	character_record = $CharacterRecord
	if not game:
		return
	var name_ = game.get_state(["character", "name"])
	if not name_:
		return
	#$ProfileBtn/Label.text = name_["short"]
	var full_name = character_record.get_node("FullName")
	full_name.clear()
	var short_name = name_["elf_short"]
	if name_["elves_call"] == name_["humans_call"]:
		short_name = name_["short"]
	else:
		short_name += "/" + name_["human_short"]
	full_name.add_text(name_["full"] + "  (%s)" % short_name)
	var full_name_def = character_record.get_node("FullNameDefinition")
	full_name_def.clear()
	full_name_def.append_text("[i]" + name_["full_def"] + "[/i]")
	
	var full_story = character_record.get_node("StoryContainer/Story")

	for item in full_story.get_children():
		item.free()

	var story = game.get_state(["story"])
	for item in story:
		#full_story.append_text(
			#"-  "
		#	item["narrative"]
		#	+ ("."	if item["narrative"][-1] not in [".", "!", "?"] else "")
		#	+ "\n"
		#)
		var line = SmartLabel.instantiate()
		line.raise_to_ui_layer = false
		line.fit_content = true
		line.custom_minimum_size = Vector2(0, 90)
		#line.append_text(item["narrative"])
		line.text = item["narrative"] + ("."	if item["narrative"][-1] not in [".", "!", "?"] else "")
		full_story.add_child(line)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

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



func _on_hartbound_btn_pressed():
	glob.g.player.mode = status.MODE.ELF


func _on_elk_btn_pressed():
	glob.g.player.mode = status.MODE.ELK


func _on_ride_button_pressed():
	glob.g.player.mode = status.MODE.RIDER


func _on_hold_position_button_pressed():
	$PartySlot/HoldPositionButton.toggle()
	glob.g.player.hold_position = $PartySlot/HoldPositionButton.is_on
