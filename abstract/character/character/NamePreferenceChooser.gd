extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if $"../PreferenceSelect".value != null and $"../Proceed".disabled:
		$"../Proceed".disabled = false
		$"../Proceed".text = "Continue"


func on_start():
	var NAME = $"../../Saver".NAME
	$"../NewCharacterTitle".clear()
	$"../NewCharacterTitle".append_text(
		NAME["human_short"]
	)
	for t in $"../PreferenceSelect".get_children():
		t.text = t.text.format(NAME)


func _on_no_pressed():
	var NAME = $"../../Saver".NAME
	NAME["short"] = NAME["elf_short"]
	NAME["elves_call"] = NAME["elf_short"]
	NAME["humans_call"] = NAME["elf_short"]
	$"../../Saver".on_name_edited(NAME)
	$"/root/Game".add_resolution($"../PreferenceSelect/No/UseElvenName".id)


func _on_kinda_pressed():
	var NAME = $"../../Saver".NAME
	NAME["short"] = NAME["elf_short"]
	NAME["elves_call"] = NAME["elf_short"]
	NAME["humans_call"] = NAME["human_short"]
	$"../../Saver".on_name_edited(NAME)
	$"/root/Game".add_resolution($"../PreferenceSelect/Kinda/UseBothNames".id)


func _on_yes_pressed():
	var NAME = $"../../Saver".NAME
	NAME["short"] = NAME["human_short"]
	NAME["elves_call"] = NAME["human_short"]
	NAME["humans_call"] = NAME["human_short"]
	$"../../Saver".on_name_edited(NAME)
	$"/root/Game".add_resolution($"../PreferenceSelect/Yes/UseHumanName".id)
