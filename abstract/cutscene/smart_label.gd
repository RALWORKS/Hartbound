extends RichTextLabel

class_name SmartLabel

@onready var game = $"/root/Game"
@export var raise_to_ui_layer = true

# Called when the node enters the scene tree for the first time.
func _ready():
	replace()

func replace():
	var new_text = $StateTagReplacer.replace(text)
	if not text:
		return
	$".".clear()
	$".".append_text(new_text)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
