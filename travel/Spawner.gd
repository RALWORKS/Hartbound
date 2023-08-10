extends Node2D

@export var spawn_to = ".."
@export var position_from = "."

var character = preload("res://character/character.tscn")
var priestess = preload("res://character/priestess.tscn")
var priestess_instance = null
var follower = false
var spawn_on_ready = false

# Called when the node enters the scene tree for the first time.
func _ready():
	var game = $"/root/Game"
	if not game:
		return
	follower = game.get_state(["micro_progress", "priestess_follows"])


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func _spawn(c, shift):
	var position_x = $".".position.x
	var position_y = $".".position.y
	
	if position_from != ".":
		var outer: Node2D = get_node(position_from)
		var rot = outer.rotation
		
		var _position = Vector2(position_x, position_y).rotated(rot)
		position_x = _position.x
		position_y = _position.y
		
		position_x += outer.position.x + shift.x
		position_y += outer.position.y + shift.y
	
	var child = c.instantiate()
	child.position.x = position_x + shift.x
	child.position.y = position_y + shift.y
	
	child.arrived_with_player = true
	get_node(spawn_to).add_child(child)
	
	return child


func spawn(g):
	_spawn(character, Vector2(0, 0))
	follower = g.get_state(["micro_progress", "priestess_follows"])
	if follower:
		priestess_instance = _spawn(priestess, Vector2(-30, 0))
		priestess_instance.start_following(g)
