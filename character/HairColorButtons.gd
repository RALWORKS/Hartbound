extends Node2D

func _set_hair(ix):
	$"../WrapAndScale/Character".set_hair_color(ix)
	$"..".refresh_indicators()

# Called when the node enters the scene tree for the first time.
func _ready():
	var x = 0
	var y = 0
	var ix = 0
	for hex in $"../WrapAndScale/Character".TEXTURES["hair-color"]:
		var b = Button.new()
		var s = StyleBoxFlat.new()
		s.bg_color = hex
		b.add_theme_stylebox_override("normal", s)
		b.position = Vector2(x * 50, y * 50)
		b.size = Vector2(30, 30)
		b.connect("pressed", func (): _set_hair(ix))
		$".".add_child(b)
		x += 1
		ix += 1
		if x > 1:
			x = 0
			y += 1
		


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
	
	
