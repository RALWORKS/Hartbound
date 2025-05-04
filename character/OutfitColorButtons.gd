extends Node2D
@export var is_accent = false

func _set_outfit(ix):
	if is_accent:
		$"../Window/WrapAndScale/Character".set_accent_color(ix)
	else:
		$"../Window/WrapAndScale/Character".set_outfit_color(ix)
	$"..".refresh_indicators()

# Called when the node enters the scene tree for the first time.
func _ready():
	var x = 0
	var y = 0
	var ix = 0
	var opts =  $"../Window/WrapAndScale/Character".TEXTURES["outfit-color-1"]
	if is_accent:
		opts =  $"../Window/WrapAndScale/Character".TEXTURES["outfit-color-2"]
	for hex in opts:
		var b = Button.new()
		var s = StyleBoxFlat.new()
		s.bg_color = hex
		b.add_theme_stylebox_override("normal", s)
		b.position = Vector2(x * 50, y * 50)
		b.size = Vector2(30, 30)
		b.connect("pressed", func (): _set_outfit(ix))
		$".".add_child(b)
		x += 1
		ix += 1
		if x > 2:
			x = 0
			y += 1
		


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

