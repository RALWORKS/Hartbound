extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	$"../AcceptName".disabled = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func _on_text_edit_text_changed():
	$"/root/Game".set_state(["savefile_name"], $TextEdit.text)
	var t = $"/root/Game".get_state(["savefile_name"])
	$"../AcceptName".disabled = t and t.length() < 3
