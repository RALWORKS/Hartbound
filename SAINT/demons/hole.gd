extends Sprite2D


func _on_area_2d_body_entered(body):
	if "is_player" in body and body.is_player():
		body.immune = true


func _on_area_2d_body_exited(body):
	if "is_player" in body and body.is_player():
		body.immune = false
