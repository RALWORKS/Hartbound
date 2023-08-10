extends Node2D


var character_texture_settings = {}
var profile_texture_settings = {}

@export var send_data_to: Node

func refresh_texture():
	character_texture_settings = $Profile.load_character_texture()
	refresh_indicators()

# Called when the node enters the scene tree for the first time.
func _ready():
	refresh_indicators()


func refresh_indicators():
	var ch = $Profile/img/Character
	var pr = $Profile
	character_texture_settings = ch.texture_settings
	profile_texture_settings = pr.texture_settings
	
	if send_data_to:
		send_data_to.on_character_edited(character_texture_settings)
		send_data_to.on_profile_edited(profile_texture_settings)

	for pair in [
		[$BgBtn, "bg", "Background"],
		[$FilterBtn, "filter", "Filter"],
		[$ShotBtn, "shot", "Camera Angle"],
	]:
		var l = pr.TEXTURES[pair[1]].size()
		var cur = pr.texture_settings[pair[1]] + 1
		pair[0].set_text(pair[2] + "  (" + str(cur) + "/" + str(l) + ")")
	
	for pair in [
		[$EyesBtn, "eyes", "Facial Features"],
		[$FaceBtn, "face", "Face Shape"],
	]:
		var l = ch.TEXTURES[pair[1]].size()
		var cur = ch.texture_settings[pair[1]] + 1
		pair[0].set_text(pair[2] + "  (" + str(cur) + "/" + str(l) + ")")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func _on_skin_btn_pressed():
	$Profile.next_eyes()
	refresh_indicators()

func _on_randomize_btn_pressed():
	$Profile.randomize_features()
	refresh_indicators()


func _on_bg_btn_pressed():
	$Profile.next_bg()
	refresh_indicators()


func _on_eyes_btn_pressed():
	$Profile.next_eyes()
	refresh_indicators()


func _on_face_btn_pressed():
	$Profile.next_face()
	refresh_indicators()


func _on_shot_btn_pressed():
	$Profile.next_shot()
	refresh_indicators()

func _on_filter_btn_pressed():
	$Profile.next_filter()
	refresh_indicators()

