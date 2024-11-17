extends Node
var game = null
var player = null

var falls = 0

@export var party_help_cutscene: Resource

# Called when the node enters the scene tree for the first time.
func _ready():
	game = $".".get_tree().get_root().get_node("Game")

func jack_in():
	player.connect("fell", player_fell)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if not player and game.player:
		player = game.player
		jack_in()


func player_fell():
	falls += 1
	if falls == 4:
		$"..".start_cutscene(party_help_cutscene)
