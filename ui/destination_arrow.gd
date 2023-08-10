extends Node2D

var game = null
var world = null
@export var marker: Dictionary = {}

# Called when the node enters the scene tree for the first time.
func _ready():
	game = get_tree().get_root().get_node("Game")
	world = game.get_node("MainScreen/World")
	# scene = world.get_node("Scene")
#	make_destination_marker(scene)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func make_destination_marker(scene):
#	marker = {
#		"ring": self,
#		"arrow": duplicate(),
#	}
	if scene == null or scene.get_node_or_null("YSort") == null:
		return
	marker["ring"] = self
	marker["arrow"] = duplicate()
	marker["ring"].get_node("Ring").set_deferred("visible", true)
	marker["arrow"].get_node("Arrow").set_deferred("visible", true)
	scene.add_child(marker["ring"])
	scene.move_child(marker["ring"], scene.get_node("YSort").get_index())
	scene.add_child(marker["arrow"])
		
	marker["ring"].get_node("Bounce").play("RESET")
	marker["arrow"].get_node("Bounce").play("RESET")

func marker_walk_mode():
	if marker == {}:
		return
	marker["ring"].set_deferred("visible", true)
	var label = marker["arrow"].get_node("Label")
	label.set_deferred("visible", false)

func marker_x_mode():
	if marker == {}:
		return
	marker["ring"].set_deferred("visible", false)
	var label = marker["arrow"].get_node("Label")
	label.set_deferred("visible", true)
	label.text = game.staged_action_node.title
	

func move_marker(new_position):
	if marker == {}:
		return
	marker["ring"].position = new_position
	marker["arrow"].position = new_position

func show_marker():
	if marker == {}:
		return
	marker["ring"].set_deferred("visible", true)
	marker["arrow"].set_deferred("visible", true)

func hide_marker():
	if marker == {}:
		return
	marker["ring"].set_deferred("visible", false)
	marker["arrow"].set_deferred("visible", false)
