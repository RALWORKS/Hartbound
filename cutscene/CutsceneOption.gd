extends Button


@export var to: CutsceneNode
@export var sub_node_parent: Node

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func _on_pressed():
	if disabled:
		return
	if $"..".just_clicked:
		return
	$"..".leave()
	if to != null:
		to.start()
	else:
		$"/root/Game/Chapter".end_cutscene()
