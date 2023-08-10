extends Node2D

@export var starting_page: CutsceneNode

# Called when the node enters the scene tree for the first time.
func _ready():
	for page in self.get_children():
		page.visible = false
		
#	start()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func start():
	if starting_page:
		starting_page.start()
