extends Area2D

signal forward_move
signal reverse_move

var ix = ""

@export var is_crossed = false
@onready var paper = Sprite2D.new()
@onready var line = make_line()
@onready var tx = ImageTexture.new()

var staged = false
# Called when the node enters the scene tree for the first time.
func _ready():
	paper.position = Vector2(-position.x, -position.y)
	paper.centered = false
	add_child(paper)


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
	if is_crossed:
		emit_signal("forward_move")
	else:
		emit_signal("reverse_move")

func erase():
	print("erase")
	line.fill("#00000000")
	tx.set_image(line)
	paper.texture = tx
	is_crossed = false
	$Shade.set_deferred("visible", is_crossed)

func make_line():
	return Image.create(3508, 2480, false, Image.FORMAT_RGBA8)
