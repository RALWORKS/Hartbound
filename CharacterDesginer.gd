extends Node2D


var texture_settings = {}
@export var send_data_to: Node

func init_default_texture(gender):
	$WrapAndScale/Character.init_default_texture(gender)
	refresh_indicators()

# Called when the node enters the scene tree for the first time.
func _ready():
	refresh_indicators()

func refresh_texture():
	texture_settings = $WrapAndScale/Character.load_texture()


func refresh_indicators():
	var ch = $WrapAndScale/Character.get_node("char")
	texture_settings = ch.texture_settings
	if send_data_to and send_data_to.has_method("on_character_edited"):
		send_data_to.on_character_edited(texture_settings)
		send_data_to.on_character_sprite_edited(texture_settings)

	for pair in [
		[$OutfitBtn, "outfit", "Outfit"],
		[$SkinColourBtn, "skin-color", "Skin Colour"],
		[$BuildBtn, "build", "Build"],
		[$HairstyleBtn, "hair", "Hair"],
		[$HairColourBtn, "hair-color", "Hair Colour"],
		[$OutfitColourBtn, "outfit-color-1", "Outfit Colour"],
	]:
		var l= ch.TEXTURES[pair[1]].size()
		var cur = ch.texture_settings[pair[1]] + 1
		pair[0].set_text(pair[2] + "  (" + str(cur) + "/" + str(l) + ")")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func _on_skin_btn_pressed():
	$WrapAndScale/Character/char.next_skin()
	refresh_indicators()


func _on_build_btn_pressed():
	$WrapAndScale/Character/char.next_build()
	refresh_indicators()


func _on_outfit_btn_pressed():
	$WrapAndScale/Character/char.next_outfit()
	refresh_indicators()


func _on_check_button_toggled(button_pressed):
	if button_pressed:
		$WrapAndScale/Character/char_anims.play("Rotate")
	else:
		$WrapAndScale/Character/char_anims.stop()


func _on_hair_btn_pressed():
	$WrapAndScale/Character.next_hair()
	refresh_indicators()


func _on_outfit_colour_btn_pressed():
	$WrapAndScale/Character.next_outfit_color()
	refresh_indicators()


func _on_hair_colour_btn_pressed():
	$WrapAndScale/Character.next_hair_color()
	refresh_indicators()


func _on_skin_colour_btn_pressed():
	$WrapAndScale/Character.next_skin_color()
	refresh_indicators()


func _on_randomize_btn_pressed():
	$WrapAndScale/Character.randomize_features()
	refresh_indicators()
