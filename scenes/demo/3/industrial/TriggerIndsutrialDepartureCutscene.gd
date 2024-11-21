extends Area2D
@export var cutscene: Resource

var triggered = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass



func _on_body_entered(body:Node):
	if not body.has_method("is_player") or not body.is_player():
		return
	if not cutscene:
		return
	if triggered:
		return
	triggered = true
	var game = $".".get_tree().get_root().get_node("Game")
	game.get_node("Chapter").start_cutscene(cutscene)
