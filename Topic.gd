extends Node

@export var on_play: Node

var sub_topics = []

func _show_topic_in_game(actor):
	# TODO
	pass

func play(actor):
	_show_topic_in_game(actor)
	if on_play:
		on_play.action(actor)
	


# Called when the node enters the scene tree for the first time.
func _ready():
	sub_topics = get_children()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
