extends Sprite2D

@export var area: Area2D
@export var base_modulate = "#dbdbca"
@export var highlight = "#ffffec"

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if area.is_active:
		modulate = highlight
	else:
		modulate = base_modulate
