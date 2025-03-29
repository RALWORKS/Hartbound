extends Button


var game

var game_save_menu = preload("res://ui/save_menu/game_save_menu.tscn")

func _ready():
	$ToolTip.set_deferred("visible", false)
	enable()

func _get_game():
	if game == null:
		game = $"/root/Game"
	return game

func disable():
	$".".self_modulate = "#ddddddff"
	$Icon.self_modulate = "#ffffff66"
	disabled = true

func enable():
	$".".self_modulate = Color(0.3, 0.3, 0.3, 1.0)
	$Icon.self_modulate = "#ffffffff"
	disabled = false

func _process(_delta):
	var ch = _get_game().get_node_or_null("Chapter")
	if ch and ch.cutscene == null and ch.active_map == null:
		if disabled:
			enable()
		return
	if not disabled:
		disable()


func _on_pressed():
	$"/root/Game/Chapter".start_cutscene(game_save_menu)
	_on_mouse_exited()


func _on_mouse_entered():
	if $ToolTip.visible:
		return
	$ToolTip.visible =  true


func _on_mouse_exited():
	if not $ToolTip.visible:
		return
	$ToolTip.visible = false
