extends Node2D


var game

# Called when the node enters the scene tree for the first time.
func _ready():
	var a = get_child(-1)
	remove_child(a)
	$InteractionArea.add_child(a)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _get_game():
	if game == null:
		game = $"/root/Game"
	return game

func action():
	pass

#func camp():
#	_get_game().bedtime()

func range_entered_action():
	var g = _get_game()
	if not g.is_night() and not g.injured:
		return
	g.can_camp = true

func range_exited_action():
	_get_game().can_camp = false
	

func on_click_override():
	return


func _on_tree_exiting():
	_get_game().can_camp = false
