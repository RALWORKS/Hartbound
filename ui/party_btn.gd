extends Button

@export var character_id: String = ""


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func talk():
	var ch = $"/root/Game/Chapter"
	var sc = ch.get_dialogue_by_id(character_id)
	ch.start_cutscene(sc)

func is_travelling():
	var ch = get_node_or_null("/root/Game/Chapter")
	if not ch:
		return false
	return ch.active_travel_stretch != null or ch.active_map != null

func _on_pressed():
	if is_travelling():
		return
	
	talk()


func _on_mouse_entered():
	if is_travelling():
		$Disable4Travel.visible = true


func _on_mouse_exited():
	$Disable4Travel.visible = false
