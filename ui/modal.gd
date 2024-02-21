extends Panel

@export var is_cached = false
@export var title = "Window"
@export var wrapper: Node = null
var game = null

# Called when the node enters the scene tree for the first time.
func _ready():
	game = get_tree().get_root().get_node("Game")
	$TitleBar/Exit.connect("pressed", close)
	#$".".connect("focus_exited", close)
	$TitleBar/Title.clear()
	$TitleBar/Title.append_text(title)
	if is_cached:
		visible = false

func set_title(t):
	title = t
	$TitleBar/Title.clear()
	$TitleBar/Title.append_text(title)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func set_description(d):
	$Description.append_text(d)

func close():
	game.remove_modal($".")
	if wrapper:
		wrapper.on_close()
	if is_cached:
		self.visible = false
	elif wrapper:
		wrapper.call_deferred("free")
	else:
		call_deferred("free")

func open(g):
	if wrapper:
		wrapper.on_open(g)
	if is_cached:
		visible = true
	elif wrapper:
		g.add_child(wrapper)
	else:
		g.add_child($".")
	g.add_modal($".")
	$".".set_focus_mode(FOCUS_ALL)
	$".".grab_focus()
