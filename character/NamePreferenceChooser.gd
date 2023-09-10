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
	NAME["use_human_short"] = false
	NAME["short"] = NAME["elf_short"]
	$"../../Saver".on_name_edited(NAME)


func _on_kinda_pressed():
	var NAME = $"../../Saver".NAME
	NAME["use_human_short"] = true
	NAME["short"] = NAME["elf_short"]
	$"../../Saver".on_name_edited(NAME)


func _on_yes_pressed():
	var NAME = $"../../Saver".NAME
	NAME["use_human_short"] = true
	NAME["short"] = NAME["human_short"]
	$"../../Saver".on_name_edited(NAME)
