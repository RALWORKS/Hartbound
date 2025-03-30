extends Button

@export var character_id: String = ""


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func talk():
	var ch = $"/root/Game/Chapter"
	var sc = ch.get_dialogue_by_id(character_id)
	ch.start_cutscene(sc)

func _on_pressed():
	talk()
