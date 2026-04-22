extends Button

var game

var debounce_tooltip_on = false
var debounce_tooltip_off = false

var was_disabled = true

func _ready():
	$ToolTip.set_deferred("visible", false)
	disabled = true
	disable()

func _get_game():
	if game == null:
		game = $"/root/Game"
	return game

func disable():
	$".".self_modulate = "#ddddddff"
	$Icon.self_modulate = "#ffffff66"
	$Glow.visible = false
	$AnimationPlayer.stop()

func stop_animations():
	$AnimationPlayer.play("RESET")
	#$CampMarker/Player.play("RESET")
	$AnimationPlayer.stop()
	#$CampMarker/Player.stop()

func enable():
	$".".self_modulate = "#222222ff"
	$Icon.self_modulate = "#ffffffff"
	$Glow.visible = true
	$AnimationPlayer.play("glow")
	$CampMarker/Player.play("show")

func refresh_disabled():
	if disabled == was_disabled:
		return
	was_disabled = disabled
	if disabled:
		disable()
		return
	enable()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	disabled = not status.can_camp
	refresh_disabled()


func _on_pressed():
	if disabled:
		return
	_on_mouse_exited()
	glob.g.bedtime()


func _on_mouse_entered():
	if $ToolTip.visible:
		return
	$ToolTip.visible =  true


func _on_mouse_exited():
	if not $ToolTip.visible:
		return
	$ToolTip.visible = false
