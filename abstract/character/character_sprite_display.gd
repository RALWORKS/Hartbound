extends Sprite2D

@onready var char = $Window/WrapAndScale/Character

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


var CONTROLLED_ELEMENTS = [
	"skin", 
	"skin-color",
	"hair",
	"hair-color",
	"outfit",
	"outfit-color-1",
	"outfit-color-2",
	"build",
	"face",
	"eyes",
	"pattern",
	]

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func randomize_features():
	char.randomize_features()

func next_hair():
	char.next_hair()

func next_outfit_color():
	char.next_outfit_color()

func next_outfit_pattern():
	char.next_outfit_pattern()

func next_accent_color():
	char.next_accent_color()

func next_hair_color():
	char.next_hair_color()

func next_skin_color():
	char.next_skin_color()

func set_skin(ix):
	char.set_skin(ix)

func set_hair(ix):
	char.set_hair(ix)

func set_eyes(ix):
	char.set_eyes(ix)

func set_face(ix):
	print("SET FACE: ", ix)
	char.set_face(ix)

func set_hair_color(ix):
	char.set_hair_color(ix)

func set_outfit_color(ix):
	char.set_outfit_color(ix)

func set_outfit(ix):
	char.set_outfit(ix)

func set_outfit_pattern(ix):
	char.set_outfit_pattern(ix)

func set_accent_color(ix):
	char.set_accent_color(ix)

func set_build(ix):
	char.set_build(ix)

func stop_daylight_cycle():
	$Window/DaylightFilter/AnimationPlayer.stop()
	$Window/DaylightFilter.time = 0.3

func start_daylight_cycle():
	$Window/DaylightFilter/AnimationPlayer.play("base")
	
func start_rotation():
	$Window/WrapAndScale/Character.animate_rotation()

func stop_rotation():
	$Window/WrapAndScale/Character.stop_animations()

func save_texture():
	var next_t = {}
	var t = $Window/WrapAndScale/Character.get_texture_settings()
	for key in t:
		if key in CONTROLLED_ELEMENTS:
			state.set_state(["character", "texture", key], t[key])

func refresh():
	$Window/WrapAndScale/Character.load_texture()

func char_texture_options():
	return $Window/WrapAndScale/Character.char_texture_options()
