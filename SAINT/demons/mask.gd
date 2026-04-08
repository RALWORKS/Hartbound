extends Polygon2D

@export var area: Area2D

func _ready():
	area.connect("body_entered", _on_area_2d_body_entered)
	area.connect("body_exited", _on_area_2d_body_exited)


func _on_area_2d_body_entered(body):
	if "is_player" in body and body.is_player():
		body.immune = true


func _on_area_2d_body_exited(body):
	if "is_player" in body and body.is_player():
		body.immune = false
