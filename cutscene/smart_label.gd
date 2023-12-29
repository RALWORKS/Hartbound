extends RichTextLabel

@onready var game = $"/root/Game"

# Called when the node enters the scene tree for the first time.
func _ready():
	var new_text = $StateTagReplacer.replace(text)
	$".".clear()
	$".".append_text(new_text)

	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
