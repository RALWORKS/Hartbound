extends Panel

var game

var party = []

var PROFILES = {
	"taylor": preload("res://ui/taylor_btn.tscn"),
	"nate": preload("res://ui/nate_party_btn.tscn"),
	"jerry": preload("res://ui/jerry_btn.tscn"),
	"brona": preload("res://ui/brona_btn.tscn"),
}

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
	var g = _game()
	var p = g.party
	
	if p == party:
		return
	
	party = p
	update_party()

func update_party():
	print("UPDATE PARTY")
	for c in get_children():
		c.free()
	
	var y = 14
	var pad = 18
	var inc = 190 + pad
	
	for p in party:
		var btn = PROFILES[p].instantiate()
		btn.position = Vector2(0, y)
		add_child(btn)
		y = y + inc
