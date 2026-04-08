extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass



func _on_engineer_pressed():
	$"../../Saver".set_job("engineer")
	$"../Proceed".disabled = false
	$"../Proceed".text = "Proceed"
	$"../PreferenceSelect/Engineer/RichTextLabel".add_theme_color_override("default_color", "#404040")
	$"../PreferenceSelect/Medic/RichTextLabel".add_theme_color_override("default_color", "#7c7c7c")


func _on_medic_pressed():
	$"../../Saver".set_job("medic")
	$"../Proceed".disabled = false
	$"../Proceed".text = "Proceed"
	$"../PreferenceSelect/Medic/RichTextLabel".add_theme_color_override("default_color", "#404040")
	$"../PreferenceSelect/Engineer/RichTextLabel".add_theme_color_override("default_color", "#7c7c7c")
