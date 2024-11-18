extends Node
var game = null
var player = null

var falls = 0

@export var party_help_cutscene: Resource
@export var help_offered = false

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
	print("fall", falls)
	if falls > 2 and not help_offered:
		$"..".start_cutscene(party_help_cutscene)
		help_offered = true
