extends Node

@onready var g: Game = get_tree().root.get_node_or_null("Game")


var TRANSPARENT = Color(1, 1, 1, 0)
var WHITE = Color(1, 1, 1, 1)
var BLACK = Color(0, 0, 0, 1)

var UNIVERSAL_COLLISION_LAYER = 1
var ELK_COLLISION_LAYER = 3
var HARTBOUND_COLLISION_LAYER = 2
var SUB_ROOM_COLLISION_LAYER = 4
var CAMERA_COLLISIONLAYER = 16

func null_or_empty(s):
	return s == null or s.is_empty()

pass # Replace with function body.
func not_null(item):
	if item == null:
		return false
	return true

func f_of(x: Node, f: String, args: Array = []):
	return x.callv(f, args)
	
