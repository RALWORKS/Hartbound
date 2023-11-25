extends RichTextLabel

@onready var game = $"/root/Game"

# Called when the node enters the scene tree for the first time.
func _ready():
	var new_text = _replace_state_tags(text)
	$".".clear()
	$".".append_text(new_text)


func _replace_state_tags(t):
	var reg = RegEx.new()
	reg.compile("\\{[a-zA-Z,_]+\\}")
	var matches = reg.search_all("m" + text)
	
	for match_obj in matches:
		var tag = match_obj.get_string()
		if not t.contains(tag):
			continue
		var value = game.get_state(tag.replace("{", "").replace("}", "").split(","))
		t = t.replace(tag, value)
	
	return t
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
