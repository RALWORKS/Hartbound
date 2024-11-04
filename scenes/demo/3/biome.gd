extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func get_background():
	return $Background.get_children()[0]

func get_camp():
	var camps = $Camps.get_children()
	return camps[randi_range(0, camps.size() - 1)].scene.instantiate()
