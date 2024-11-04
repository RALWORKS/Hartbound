extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _on_body_entered(body):
	if not "is_player" in body or not body.is_player:
		return
	$"/root/Game/Chapter".to_map()
