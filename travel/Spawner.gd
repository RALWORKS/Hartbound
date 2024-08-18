extends Node2D

@export var spawn_to = ".."
@export var position_from = "."
@export var follower_offset = Vector2(-30, 0)

var character = preload("res://character/character.tscn")
var follower_instance = null
var follower = false
var spawn_on_ready = false

# Called when the node enters the scene tree for the first time.
func _ready():
	var game = $"/root/Game"
	if not game:
		return


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func _spawn(c, shift, x, y):
	print(x, y)
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
	if x != null and y != null:
		position_x = x
		position_y = y
	child.position.x = position_x + shift.x
	child.position.y = position_y + shift.y
	
	child.arrived_with_player = true
	get_node(spawn_to).add_child(child)
	
	return child


func spawn(g, x=null, y=null):
	var character_instance = _spawn(character, Vector2(0, 0), x, y)
	g.set_player(character_instance)
	follower = character_instance.get_follower(g)
	if follower:
		follower_instance = _spawn(follower, follower_offset, x, y)
		follower_instance.start_following(g)
