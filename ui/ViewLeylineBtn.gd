extends Button

var game

func _get_game():
	if game == null:
		game = $"/root/Game"
	return game


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var g = _get_game()
	
	if g.leyline_showing:
		$Highlight.visible = true
		$Icon.visible = false
		$".".self_modulate = Color(0.5, 0.2, 0.5, 1.0)
	else:
		$Highlight.visible = false
		$Icon.visible = true
		$".".self_modulate = Color(0.3, 0.3, 0.3, 1.0)


func _on_pressed():
	var g = _get_game()
	g.leyline()
