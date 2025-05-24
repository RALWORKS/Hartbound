extends SmartLabel

var count = 0
var old_count = 0

func refresh_context():
	count = game.context_notification_count
	if count == old_count:
		return
	old_count = count
	notify()

func notify():
	$Player.stop()
	clear()
	text = game.context_notification
	replace()
	$Player.play("show")

func _process(_delta):
	refresh_context()
