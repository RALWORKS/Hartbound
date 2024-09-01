extends Node

@export var collider: Area2D

# Called when the node enters the scene tree for the first time.
func _ready():
	collider.connect("body_entered", collide)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func collide(body):
	var g = $"/root/Game/"
	
	if not "is_player" in body or not body.is_player():
		return
	
	if body.immune:
		return
	
	g.dying = true
	$"/root/Game/MainScreen/Effects".play("pass out")
	await get_tree().create_timer(2).timeout
	g.dying = false
	g.respawn_player()
	
