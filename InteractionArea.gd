extends Area2D

@export var title: String
@export var reference_id: String
@export var description: String

var x_cursor = preload("res://cursor.tscn")
var InteractionWindow = preload("res://item/interaction_window.tscn")

var cur_window = null
var cur_cursor = null
var game = null

var in_range = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	var click = Input.is_action_just_released("click")
	var g = _get_game()
	if click and cur_cursor == null and g.staged_action_node == self:
		g.unstage_action_node(self)
	if cur_cursor:
		if g.staged_action_node == self:
			cur_cursor.set_deferred("visible", false)
		else:
			cur_cursor.set_deferred("visible", true)

func _close_action_window():
	if cur_window:
		cur_window.call_deferred("free")
	cur_window = null

func action():
	if cur_window:
		return
	
	var g = _get_game()
	cur_window = InteractionWindow.instantiate()
	
	
	$"..".add_child(cur_window)

	cur_window.connect("close_requested", _close_action_window)
	cur_window.connect("focus_exited", _close_action_window)
	g.add_child(cur_window)
	cur_window.title = title
	cur_window.set_description(description)
	cur_window.grab_focus()


func _on_mouse_entered():
	#print("mouse!")
	cur_cursor = x_cursor.instantiate()
	
	var w = $".."
	w.add_child(cur_cursor)
	cur_cursor.set_title(title)
	DisplayServer.cursor_set_shape(DisplayServer.CURSOR_POINTING_HAND)

func _on_click():	
	_get_game().staged_action_node = self
	if in_range:
		action()

func _on_input_event(_viewport, event: InputEvent, _shape_idx):
	if event.is_action("click"):
		_on_click()


func _on_mouse_exited():
	DisplayServer.cursor_set_shape(DisplayServer.CURSOR_ARROW)
	if cur_cursor == null:
		return
	cur_cursor.free()
	cur_cursor = null

func _get_game():
	if game == null:
		game = get_tree().get_root().get_node("Game")
	return game

func interact_range_entered():
	in_range = true
	if _get_game().staged_action_node == self:
		action()

func interact_range_exited():
	in_range = false
