extends Area2D

@export var title: String
@export var reference_id: String
@export_multiline var description: String
@export var cutscene: Resource
@export var cutscene_character: Node
@export var action_source: Node
@export var child_depth = 0
@export var options_container_node: Node = null
@export var get_on_open_from: Node

var x_cursor = preload("res://cursor.tscn")
var InteractionModal = preload("res://item/interaction_modal.tscn")

var cur_window = null
var cur_cursor = null
var game = null

var in_range = false

var match_narrow_chars = RegEx.create_from_string("[ ilt]")
var match_wide_chars = RegEx.create_from_string("[W]")

# Called when the node enters the scene tree for the first time.
func _ready():
	setup_indicator()
	setup_label()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	var click = Input.is_action_just_released("click")
	game = _get_game()
	if click and cur_cursor == null and game.staged_action_node == self:
		game.unstage_action_node(self)
	if cur_cursor != null:
		if game.staged_action_node == self:
			cur_cursor.set_deferred("visible", false)
		else:
			cur_cursor.set_deferred("visible", true)
	
	var scout = Input.is_action_pressed("scout") or _get_game().is_scouting
	if scout and not $indicator.visible:
		$indicator.set_deferred("visible", true)
	elif not scout and $indicator.visible:
		$indicator.set_deferred("visible", false)

func _close_action_window():
	if cur_window:
		cur_window.close()

func action():
	var g = _get_game()
	#g.move()
	
	if cutscene:
		$"/root/Game/Chapter".start_cutscene(cutscene, cutscene_character)
		return
	if get_on_open_from != null:
		get_on_open_from.on_open()
	if action_source:
		return action_source.action()
	if cur_window:
		return
	cur_window = InteractionModal.instantiate()
	cur_window.target = self
	cur_window.title = title
	cur_window.set_description(description)
	cur_window.set_options(options_container_node)
	
	cur_window.open(g)


func _on_mouse_entered():
	if process_mode == Node.PROCESS_MODE_DISABLED:
		return
	cur_cursor = x_cursor.instantiate()

	var w = $".."
	var depth_iter = 0
	while depth_iter < child_depth:
		w = w.get_parent()
		depth_iter += 1
	w.add_child(cur_cursor)
	cur_cursor.set_title(title)
	DisplayServer.cursor_set_shape(DisplayServer.CURSOR_POINTING_HAND)

func _on_click():
	if process_mode == Node.PROCESS_MODE_DISABLED:
		return
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
		game.unstage_action_node(self)

func interact_range_exited():
	in_range = false


func _on_tree_exiting():
	if cur_cursor != null:
		cur_cursor.call_deferred("free")


func setup_indicator():
	$indicator.scale.x = 1.0/global_scale.x
	$indicator.scale.y = 1.0/global_scale.y
	$indicator.rotation = 0 - global_rotation

func setup_label():
	$indicator/RichTextLabel.text = title
	var label = $indicator/RichTextLabel
	var len_title = title.length()
	var overflow = len_title - 4
	if overflow < 1:
		return
	for i in range(overflow):
		label.size.x += 10
		
	var n_narrow = match_narrow_chars.search_all(title).size()
	var n_wide = match_wide_chars.search_all(title).size()

	label.size.x = label.size.x - (6*n_narrow) + (6*n_wide)
	
