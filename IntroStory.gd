extends Node2D

var intro_story = preload("res://intro-story/intro_story.tscn")

var cur_game: Array[Node]
var cutscene
var menu: SubViewport
var game
var menu_visible = false
var menu_parent

# Called when the node enters the scene tree for the first time.
func _ready():
	start_cutscene(intro_story)
	
	game = get_tree().get_root().get_node("Game")
	menu = game.get_node("MainScreen/Menu")
	menu_parent = menu.get_parent()
	menu_parent.remove_child(menu)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func start_cutscene(cutscene_res):
	cutscene = cutscene_res.instantiate()
#	cur_game = $"../MainScreen/World".get_children()
#	for child in $"..".get_children():
#		print(child)

	$"../MainScreen/World".add_child(cutscene)
	cutscene.start()

func end_cutscene():
	cutscene.free()
#	for child in cur_game:
#		$"../MainScreen/World".add_child(child)

	var g = $"/root/Game"
	menu_parent.add_child(menu)
	g.to_chapter("create")
