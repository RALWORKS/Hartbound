@tool
extends Polygon2D

var loading = false
@export var reload = false

@export var line_color: Color = "#ff99ffff"
@export var line_width: int = 16

# Called when the node enters the scene tree for the first time.
func _ready():
	#greeble()
	outline()
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if reload and not loading:
		outline()

func outline():
	loading = true
	$PenLine.clear_points()
	$PenLine.default_color = line_color
	$PenLine.width = line_width
	for p in self.polygon:
		$PenLine.add_point(p)
	$PenLine.add_point(self.polygon[0])
	reload = false
	loading = false


