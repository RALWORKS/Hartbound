extends Node2D

func name_updated():
	_refresh_proceed()

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _disable_proceed():
	var btn = $"../Proceed"
	btn.text = "[Choose a name to proceed]"
	btn.disabled = true

func _refresh_proceed():
	var btn = $"../Proceed"
	var n = $"../CharacterNamer".selected_name
	btn.text = "> Continue as " + n["name"] + "  (" + n["full_name"] + ")"
	btn.disabled = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if $"../CharacterNamer".selected_name == null and not $"../Proceed".disabled:
		_disable_proceed()
	elif $"../CharacterNamer".selected_name != null and $"../Proceed".disabled:
		_refresh_proceed()
