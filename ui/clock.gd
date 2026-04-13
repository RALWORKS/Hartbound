extends Node2D

var game: Game

# Called when the node enters the scene tree for the first time.
func _ready():
	game = $"/root/Game"

func _get_game():
	if game == null:
		game = $"/root/Game"
	return game

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	refresh()

func refresh():
	var g = _get_game()
	if g == null:
		return
	$Time.text = $TimeUtils.format_time_24h(t.proportional_time())
	$Day.text = str(t.get_date() + 1)
