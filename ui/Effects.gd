extends CanvasLayer

var EFFECTS

# Called when the node enters the scene tree for the first time.
func _ready():
	EFFECTS = {
		"pass out": [$BlackStarAnimation, "close", 3],
		"come to": [$BlackStarAnimation, "open", 3],
	}


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func play(effect):
	if effect.length() == 0:
		return
	if not effect in EFFECTS:
		push_error("FX '" + effect + "' not recognized by Game/Effects")
		return
	var data = EFFECTS[effect]
	
	data[0].visible = true
	data[0].call(data[1])
	await get_tree().create_timer(data[2]).timeout
	data[0].visible = false
