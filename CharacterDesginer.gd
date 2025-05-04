extends Node2D


var texture_settings = {}
@export var send_data_to: Node
@export var profile_designer: Node

func init_default_texture(gender):
	$Window/WrapAndScale/Character.init_default_texture(gender)
	refresh_indicators()

# Called when the node enters the scene tree for the first time.
func _ready():
	refresh_indicators()

func refresh_texture():
	texture_settings = $Window/WrapAndScale/Character.load_texture()


func refresh_indicators():
	var ch = $Window/WrapAndScale/Character.get_node("char")
	texture_settings = ch.texture_settings
	if send_data_to and send_data_to.has_method("on_character_edited"):
		send_data_to.on_character_edited(texture_settings)
		send_data_to.on_character_sprite_edited(texture_settings)

	for pair in [
		[$OutfitBtn, "outfit", "Outfit"],
		[$OutfitPatternBtn, "pattern", "Fabric Pattern"],
		[$SkinColourBtn, "skin-color", "Skin Colour"],
		[$BuildBtn, "build", "Build"],
		[$HairstyleBtn, "hair", "Hair"],
		[$HairColourBtn, "hair-color", "Hair Colour"],
		[$OutfitColourBtn, "outfit-color-1", "Outfit Colour"],
		[$AccentColourBtn, "outfit-color-2", "Accent Colour"],
	]:
		var l = ch.TEXTURES[pair[1]].size()
		var cur = ch.texture_settings[pair[1]] + 1
		pair[0].set_text(pair[2] + "  (" + str(cur) + "/" + str(l) + ")")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func _on_skin_btn_pressed():
	$Window/WrapAndScale/Character/char.next_skin()
	refresh_indicators()


func _on_build_btn_pressed():
	$Window/WrapAndScale/Character/char.next_build()
	refresh_indicators()


func _on_outfit_btn_pressed():
	$Window/WrapAndScale/Character/char.next_outfit()
	refresh_indicators()


func _on_check_button_toggled(button_pressed):
	if button_pressed:
		$Window/WrapAndScale/Character/char.play("Rotate")
	else:
		$Window/WrapAndScale/Character/char.stop()


func _on_hair_btn_pressed():
	$Window/WrapAndScale/Character.next_hair()
	refresh_indicators()


func _on_outfit_colour_btn_pressed():
	$Window/WrapAndScale/Character.next_outfit_color()
	refresh_indicators()


func _on_hair_colour_btn_pressed():
	$Window/WrapAndScale/Character.next_hair_color()
	refresh_indicators()


func _on_skin_colour_btn_pressed():
	$Window/WrapAndScale/Character.next_skin_color()
	refresh_indicators()

func randomize_character():
	$Window/WrapAndScale/Character.randomize_features()
	if profile_designer != null:
		profile_designer.shuffle()
	
	refresh_indicators()


func _on_randomize_btn_pressed():
	randomize_character()

func _on_accent_colour_btn_pressed():
	$Window/WrapAndScale/Character.next_accent_color()
	refresh_indicators()


func _on_outfit_pattern_btn_pressed():
	$Window/WrapAndScale/Character.next_outfit_pattern()
	refresh_indicators()
