extends Panel

var game

# Called when the node enters the scene tree for the first time.
func _ready():
	refresh_party()

func _game():
	if game:
		return game
	game = $"/root/Game"
	game.connect("check_party", refresh_party)
	return game

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if _game().chapter == null:
		return
	#refresh_party()
	if visible:
		if _game().chapter.cutscene != null:
			visible = false
	else:
		if _game().chapter.cutscene == null:
			visible = true

func refresh_party():
	update_party()

func update_party():
	return
#	for c in get_children():
#		c.free()
#
#	var y = 14
#	var pad = 18
#	var inc = 190 + pad
#
#	for p in party:
#		if not p.length():
#			return
#		var btn = PROFILES[p].instantiate()
#		btn.position = Vector2(0, y)
#		add_child(btn)
#		y = y + inc
