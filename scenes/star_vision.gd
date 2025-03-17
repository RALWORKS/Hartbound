extends CanvasLayer

class_name StarVision


var passout: Node2D
var anim: AnimationPlayer

@export var LINE_WIDTH: int = 30
@export var LINE_COLOR: Color = Color("white")


# Called when the node enters the scene tree for the first time.
func _ready():
	$Contents.modulate = "#ffffff00"
	passout = $Contents/BlackStarAnimation
	anim = $AnimationPlayer
	visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func style_line(l: Line2D):
	l.width = LINE_WIDTH
	l.default_color = LINE_COLOR
	l.joint_mode = Line2D.LINE_JOINT_ROUND
	l.end_cap_mode = Line2D.LINE_CAP_ROUND
	l.begin_cap_mode = Line2D.LINE_CAP_ROUND

func set_sigil(sigil: TruePath):
	var s = sigil.fit_to_square(500)
	style_line(s)
	$Contents.add_child(s)
	s.position = Vector2(650, 350)

func show_vision():
	passout.open()
	anim.play("show")
