extends Area2D

signal cross

var ix = ""

var MAPNODE = true

@export var is_crossed = false
@onready var paper: Sprite2D
@onready var line = make_line()
@onready var tx: ImageTexture

var staged = false
# Called when the node enters the scene tree for the first time.
func _ready():
	ix = ix if ix else name


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_body_entered(body):
	if not "is_pencil" in body or not body.is_pencil:
		return
	staged = true


func _on_body_exited(body):
	if not "is_pencil" in body or not body.is_pencil or not staged:
		return
	staged = false
	is_crossed = not is_crossed
	$Shade.set_deferred("visible", is_crossed)
	emit_signal("cross", self)

func erase():
	if not paper:
		return
	paper.free()
	is_crossed = false
	$Shade.set_deferred("visible", false)

func make_line():
	return Image.create(3508, 2480, false, Image.FORMAT_RGBA8)

func make_paper():
	paper = Sprite2D.new()
	paper.position = Vector2(-position.x, -position.y)
	paper.centered = false
	add_child(paper)
	move_child(paper, 0)
	line = make_line()
	tx = ImageTexture.new()
	tx.set_image(line)
	paper.texture = tx
	return paper
