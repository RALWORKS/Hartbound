extends Node

@export var parent_ref = ".."

@export var collider: Area2D
@export var active = true

# Called when the node enters the scene tree for the first time.
func _ready():
	collider.connect("body_entered", collide)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func collide(body):
	
	if not "is_player" in body or not body.is_player() or not active:
		return
	
	if body.immune:
		return
	var g = $"/root/Game/"
	var callback = g.respawn_player
	var parent = get_node(parent_ref) 
	if "door" in parent:
		callback = parent.door.go
	die(callback)
	

func die(callback):
	var g = $"/root/Game/"
	if g.dying:
		return
	g.dying = true
	$"/root/Game/MainScreen/Effects".play("pass out")
	await get_tree().create_timer(2).timeout
	#g.respawn_player()
	callback.call()
	g.dying = false
