extends Node2D

var gender = null

# Called when the node enters the scene tree for the first time.
func _ready():
	$"../SetGender".disabled = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func _on_nb_pressed():
	$"../GenderSelect".reset()
	$"../GenderSelect/NB".set_pressed_no_signal(true)
	$"../../Saver".on_character_edited($"../../2/CharacterDesginer".init_default_texture("NB"))
	gender = "NB"
	$"../SetGender".disabled = false
	$"../../Saver".on_gender_edited(gender)
	$"../../DesignerNew/CharacterDesignerTabbed".randomize_features()
	#$"../../2/CharacterDesginer".randomize_character()
	
	#$"../../2/ProfileDesigner".refresh_texture()

func _on_woman_pressed():
	$"../GenderSelect".reset()
	$"../GenderSelect/Woman".set_pressed_no_signal(true)
	$"../../Saver".on_character_edited($"../../2/CharacterDesginer".init_default_texture("F"))
	gender = "F"
	$"../SetGender".disabled = false
	$"../../Saver".on_gender_edited(gender)
	#$"../../2/CharacterDesginer".randomize_character()
	$"../../DesignerNew/CharacterDesignerTabbed".randomize_features()
	#$"../../2/ProfileDesigner".refresh_texture()


func _on_man_pressed():
	$"../GenderSelect".reset()
	$"../GenderSelect/Man".set_pressed_no_signal(true)
	$"../../Saver".on_character_edited($"../../2/CharacterDesginer".init_default_texture("M"))
	gender = "M"
	$"../SetGender".disabled = false
	$"../../Saver".on_gender_edited(gender)
	#$"../../2/CharacterDesginer".randomize_character()
	$"../../DesignerNew/CharacterDesignerTabbed".randomize_features()
	#$"../../2/ProfileDesigner".refresh_texture()
