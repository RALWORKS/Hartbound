extends Window

var game = null
@export var target: Node = null

# Called when the node enters the scene tree for the first time.
func _ready():
	game = get_tree().get_root().get_node("Game")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func set_description(d):
	$Description.append_text(d)

func close():
	call_deferred("free")
	if game.cur_modal == self:
		game.cur_modal = null
	target.cur_window = null

func open(g):
	g.add_child(self)
