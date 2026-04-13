extends Button

var game

var debounce_tooltip_on = false
var debounce_tooltip_off = false

func _ready():
	$ToolTip.set_deferred("visible", false)

func _get_game():
	if game == null:
		game = $"/root/Game"
	return game


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	
	if status.is_scouting:
		$".".self_modulate = Color(0.5, 0.2, 0.5, 1.0)
	else:
		$".".self_modulate = Color(0.3, 0.3, 0.3, 1.0)


func _on_pressed():
	g.scout()


func _on_mouse_entered():
	if $ToolTip.visible:
		return
	$ToolTip.visible =  true


func _on_mouse_exited():
	if not $ToolTip.visible:
		return
	$ToolTip.visible = false
