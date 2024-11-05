extends Button

var game_save_menu = preload("res://ui/save_menu/game_save_menu.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	var ch = $"/root/Game".get_node_or_null("Chapter")
	if ch and ch.cutscene == null and ch.active_map == null:
		disabled = false
	else:
		disabled = true


func _on_pressed():
	$"/root/Game/Chapter".start_cutscene(game_save_menu)
