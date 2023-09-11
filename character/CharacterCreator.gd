extends Node2D

var creator = preload("res://character/character_creator_cutscene.tscn")

var cur_game: Array[Node]
var cutscene

# Called when the node enters the scene tree for the first time.
func _ready():
	start_cutscene(creator)


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
	cutscene.call_deferred("free")
#	for child in cur_game:
#		$"../MainScreen/World".add_child(child)

	var g = $"/root/Game"
	print(g)
	g.to_chapter(g.FIRST_CHAPTER)
