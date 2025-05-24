extends Button

var game


var Reflections = preload("res://ui/reflections.tscn")
@export var playing = false

func hint_codex():
	$CodexMarker/Player.play("show")

func _ready():
	$ToolTip.set_deferred("visible", false)
	$".".self_modulate = Color(0.3, 0.3, 0.3, 1.0)

func _get_game():
	if game == null:
		game = $"/root/Game"
	return game


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	var n_reflections = _get_game().n_reflections()
	$Circle/Label.text = str(n_reflections)
	if n_reflections > 0 and not playing:
		$AnimationPlayer.play("show")
		$Circle.visible = true
		playing = true
		return
	if playing and n_reflections == 0:
		$AnimationPlayer.play("RESET")
		$Circle.visible = false
		playing = false


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
