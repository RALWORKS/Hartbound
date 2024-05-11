extends Sprite2D

func become(some_texture):
	texture = some_texture

func on_start():
	var bg = $"../..".scene_bg
	if bg == null:
		return
	become(bg)
