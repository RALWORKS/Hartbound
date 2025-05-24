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
	if not game.chapter:
		return false
	if game.chapter.cutscene:
		return false
	if game.cur_modal:
		return false
	return true

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
	replace()
	$Player.play("show")

func _process(_delta):
	refresh_context()
	refresh_visible()
