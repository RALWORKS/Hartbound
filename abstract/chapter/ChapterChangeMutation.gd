extends ChapterEventMutation

@export var to_chapter: String

func mutate():
	var game = $".".get_tree().get_root().get_node("Game")
	game.to_chapter(to_chapter)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
