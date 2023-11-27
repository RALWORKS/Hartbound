extends Node


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func pre_init():
	var game = $".".get_tree().get_root().get_node("Game")
	var job = game.get_state(["profile", "job"])
	var a_your_profession = "a %s" % job
	if job == "engineer":
		a_your_profession = "an %s" % job
	$"../Events/StartChapter/TrainingStory".narrative = $"../Events/StartChapter/TrainingStory".narrative.format(
		{"a_profession": a_your_profession}
	)
	
	$"../DemoC1RegroupInitial".start()
	
