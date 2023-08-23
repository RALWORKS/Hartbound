extends Window

var game = null

# Called when the node enters the scene tree for the first time.
func _ready():
	game = get_tree().get_root().get_node("Game")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func close():
	visible = false
	if game.cur_modal == self:
		game.cur_modal = null

func open(_g):
	visible = true
	grab_focus()
