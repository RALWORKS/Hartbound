extends Area2D

signal forward_move
signal reverse_move

@export var is_crossed = false

var staged = false
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


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
