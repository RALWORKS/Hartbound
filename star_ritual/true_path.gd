extends Line2D

class_name TruePath

var Star = preload("res://star_ritual/star.tscn")

var sequence: Array[Star] = []


# Called when the node enters the scene tree for the first time.
func _ready():
	get_parent().sigil = self
	visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func make_stars(ritual: StarRitual):
	for p in points:
		var s: Star = Star.instantiate()
		s.position = p - position
		ritual.add_child(s)
		ritual.add_star(s)
		sequence.push_back(s)
		
