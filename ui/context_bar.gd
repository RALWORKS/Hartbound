extends SmartLabel

var count = 0
var old_count = 0

var is_visible = true
var was_visible = true

func refresh_context():
	count = game.context_notification_count
	if count == old_count:
		return
	old_count = count
	notify()

func _get_visible():
	var ret = true
	if game.chapter == null:
		return false
	if game.chapter.cutscene:
		ret = false
	if game.cur_modal:
		ret = false
	if visible and not ret:
		$Player.play("RESET")
	return ret

func refresh_visible():
	is_visible = _get_visible()
	if is_visible == was_visible:
		return
	visible = is_visible
	was_visible = is_visible

func notify():
	$Player.stop()
	clear()
	text = game.context_notification
	if text.length() == 0:
		return stop()
	replace()
	$Player.play("show", -1, 1.5)

func stop():
	$Player.play("RESET")

func _process(_delta):
	refresh_context()
	refresh_visible()
