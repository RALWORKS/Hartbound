extends Node2D

var game
var n_reflections = 0

@export var playing = false

func _get_game():
	if game == null:
		game = $"/root/Game"
	return game


func _ready():
	#set_deferred("visible", false)
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if playing:
		return
	
	var g = _get_game()
	var _n_reflections = g.n_reflections()
	
	if _n_reflections > n_reflections and g.get_node("Chapter").cutscene == null:
		n_reflections = _n_reflections
		$AnimationPlayer.play("show")
		#$Icon.visible = false
		#$".".self_modulate = Color(0.5, 0.2, 0.5, 1.0)
