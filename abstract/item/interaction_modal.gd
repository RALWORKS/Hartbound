extends Node2D
@export var title = "Interact"
@export var options_container_node: Node
@export var image_texture: Texture2D
var target = null


# Called when the node enters the scene tree for the first time.
func _ready():
	$Modal.set_title(title)
	_refresh_options()
	_refresh_image_texture()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func open(g):
	$Modal.open(g)

func close():
	$Modal.close()
	$"/root/Game".move()
	
func set_description(d):
	$Modal/ExamineBody.append_text(d)

func set_image_texture(t):
	image_texture = t
	_refresh_image_texture()

func _refresh_image_texture():
	if image_texture == null or get_node_or_null("Modal/Image") == null:
		return
	$Modal/Image.texture = image_texture

func set_options(container_node):
	options_container_node = container_node
	_refresh_options()

func _check_active_options(option):
	return option.enabled

func _refresh_options():
	if options_container_node == null:
		$Modal/Actions.visible = false
		return

	var options = options_container_node.get_children()
	if options.filter(_check_active_options).size() == 0:
		$Modal/Actions.visible = false
		return

	var y = 10
	for a in options:
		if not a.enabled:
			continue
		a.parent = self
		var btn = Button.new()
		btn.size = Vector2(510, 45)
		btn.text = a.title
		btn.position = Vector2(10, y)
		y += 53
		$Modal/Actions.add_child(btn)
		btn.connect("pressed", a.action)

func on_open(_g):
	if target == null:
		return
	target.cur_window = self

func on_close():
	if target == null:
		return
	target.cur_window = null
