extends Node

var game: Node

var NAME

# Called when the node enters the scene tree for the first time.
func _ready():
	game = $"/root".get_node_or_null("Game")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func on_character_sprite_edited(data):
	if not game:
		return
	game.set_state(["character", "texture"], data)
	$"../2/ProfileDesigner".refresh_texture()

func on_character_edited(data):
	if not game:
		return
	#game.set_state(["character", "texture"], data)
	var side_profile = game.get_node_or_null("MainScreen/RightMenu/GameMenu/ProfileBtn/Profile")
	var drawer_profile = game.get_node_or_null("MainScreen/RightMenu/GameMenu/CharacterRecord/black/Profile")
	side_profile.refresh()
	drawer_profile.refresh()
	$"../2/CharacterDesginer".refresh_texture()
	
func on_profile_edited(data):
	if not game:
		return
	#game.set_state(["profile", "texture"], data)
	var side_profile = game.get_node_or_null("MainScreen/RightMenu/GameMenu/ProfileBtn/Profile")
	var drawer_profile = game.get_node_or_null("MainScreen/RightMenu/GameMenu/CharacterRecord/black/Profile")
	side_profile.refresh()
	drawer_profile.refresh()
	$"../2/CharacterDesginer".refresh_texture()

func set_job(data):
	if not game:
		return
	game.set_state(["profile", "job"], data)

func on_name_edited(data):
	if not game:
		return
	NAME = data
	game.set_state(["character", "name"], data)
	var side_profile = game.get_node_or_null("MainScreen/RightMenu/GameMenu/ProfileBtn/Label")
	side_profile.text = data["short"]

func on_gender_edited(data):
	if not game:
		return
	game.set_state(["character", "gender"], data)
