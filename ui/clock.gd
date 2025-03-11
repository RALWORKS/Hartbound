extends Node2D

var game: Game

# Called when the node enters the scene tree for the first time.
func _ready():
	game = $"/root/Game"


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	refresh()

func refresh():
	if game == null:
		return
	visible = game.show_clock
	$Time.text = $TimeUtils.format_time_24h(game.proportional_time())
	$Day.text = str(game.get_date() + 1)
	
