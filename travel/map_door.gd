extends Area2D

var game: Game

# Called when the node enters the scene tree for the first time.
func _ready():
	game = $"/root/Game"


func _on_body_entered(body):
	if not "is_player" in body or not body.is_player or game.is_night():
		return
	$"/root/Game/Chapter".to_map()
