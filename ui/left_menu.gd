extends CanvasLayer

var show = visible
var was_shown = show

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func hint_codex():
	$ReflectionBtn.hint_codex()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	modulate_clock_visibility()
	handle_show_hide()

func handle_show_hide():
	if was_shown and not show:
		hide_self()
	elif show and not was_shown:
		show_self()
	was_shown = show

func hide_self():
	#visible = false
	$ReflectionBtn.stop_animations()
	$AnimationPlayer.play("hide")

func show_self():
	visible = true
	$AnimationPlayer.play("RESET")

func modulate_clock_visibility():
	if $ColorRect/ClockSlot.visible:
		if $"/root/Game".cur_modal != null:
			$ColorRect/ClockSlot.visible = false
			return
		if $"/root/Game".ritual:
			$ColorRect/ClockSlot.visible = false
	else:
		if $"/root/Game".cur_modal == null and not $"/root/Game".ritual:
			$ColorRect/ClockSlot.visible = true
