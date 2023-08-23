extends Node2D
@export var title = "Interact"
var target = null


# Called when the node enters the scene tree for the first time.
func _ready():
	$Modal.set_title(title)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func open(g):
	$Modal.open(g)

func close():
	$Modal.close()
	
func set_description(d):
	$Modal/ExamineBody.append_text(d)

func on_open(_g):
	target.cur_window = self

func on_close():
	target.cur_window = null
