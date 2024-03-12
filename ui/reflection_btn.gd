extends Button

var game


var Reflections = preload("res://ui/reflections.tscn")

func _ready():
	$ToolTip.set_deferred("visible", false)
	$".".self_modulate = Color(0.3, 0.3, 0.3, 1.0)

func _get_game():
	if game == null:
		game = $"/root/Game"
	return game


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func _on_pressed():
	var reflections = Reflections.instantiate()
	reflections.open(_get_game())


func _on_mouse_entered():
	if $ToolTip.visible:
		return
	$ToolTip.visible =  true


func _on_mouse_exited():
	if not $ToolTip.visible:
		return
	$ToolTip.visible = false
