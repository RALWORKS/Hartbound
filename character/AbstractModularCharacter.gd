extends Sprite2D

@export var body: Node
@export var front_arm: Node
@export var face: Node
@export var profile_head: Node
@export var profile_face: Node
@export var hair_back: Node
@export var hair_front: Node
@export var profile_hair: Node
@export var profile_hair_front: Node
@export var clothes: Node
@export var clothes_pattern: Node
@export var clothes_accent: Node
@export var front_sleeve: Node
@export var front_sleeve_accent: Node
@export var profile_shirt: Node
@export var profile_features: Node
@export var character_img: Node
@export var anchor_bottom = false

@export var frame_spacing: float = 0.3

var game = null
var world = null

var ANIMATIONS = {
	"down": [1, 0, 2, 0],
	"down-stopped": [0],
	"up": [4, 3, 5, 3],
	"up-stopped": [3],
	"left": [15, 17, 16, 17],
	"left-stopped": [17],
	"right": [13, 12, 14, 12],
	"right-stopped": [12],
	"down-right": [10, 9, 11, 9],
	"down-right-stopped": [9],
	"down-left": [18, 20, 19, 20],
	"down-left-stopped": [20],
	"up-right": [7, 6, 8, 6],
	"up-right-stopped": [6],
	"up-left": [21, 23, 22, 23],
	"up-left-stopped": [23],
	"Rotate": [0, 9, 12, 6, 3, 23, 17, 20]
}

func verb(base):
	if base in ["is", "are"]:
		return 

var PRONOUNS = {
	"M": PRONOUNS_M,
	"F": PRONOUNS_F,
	"NB": PRONOUNS_NB,
}

var PRONOUNS_M = {
	"they": "he",
	"them": "him",
	"their": "his",
	"theirs": "his",
	"they're": "he's",
	"they are": "he is",
	"are": "is",
	"were": "was",
	"have": "has",
	"had": "had",
	"they were": "he was",
	"[present tense]": "s",
}

var PRONOUNS_F = {
	"they": "she",
	"them": "her",
	"their": "her",
	"theirs": "her",
	"they're": "she's",
	"they are": "she is",
	"they were": "she was",
	"are": "is",
	"were": "was",
	"have": "has",
	"had": "had",
	"[present tense]": "s",
}
var PRONOUNS_NB = {
	"they": "they",
	"them": "them",
	"their": "their",
	"theirs": "theirs",
	"they're": "they're",
	"they are": "they are",
	"they were": "they were",
	"are": "is",
	"were": "were",
	"have": "have",
	"had": "had",
	"[present tense]": "",
}

func play(animation_title):
	$AnimationPlayer.play("movement/" + animation_title)

func stop():
	$AnimationPlayer.stop()

func init_default_texture(gender):
	texture_settings = DEFAULT_TEXTURES_NB
	if gender == "M":
		texture_settings = DEFAULT_TEXTURES_M
	elif gender == "F":
		texture_settings = DEFAULT_TEXTURES_F
	texture_updated()
	return texture_settings

func randomize_features():
	texture_settings = {
		"skin": randi() % TEXTURES["skin"].size(),
		"skin-color": randi() % TEXTURES["skin-color"].size(),
		"hair": randi() % TEXTURES["hair"].size(),
		"hair-color": randi() % TEXTURES["hair-color"].size(),
		"outfit": randi() % TEXTURES["outfit"].size(),
		"outfit-color-1": randi() % TEXTURES["outfit-color-1"].size(),
		"outfit-color-2": randi() % TEXTURES["outfit-color-2"].size(),
		"build": randi() % TEXTURES["build"].size(),
		"pattern": randi() % (N_PATTERNS + 1),
		"face": texture_settings["face"],
		"eyes": texture_settings["eyes"],
	}
	texture_updated()


var DEFAULT_TEXTURES_F = {
	"skin": 0,
	"skin-color": 1,
	"hair": 2,
	"hair-color": 0,
	"outfit": 1,
	"outfit-color-1": 2,
	"outfit-color-2": 2,
	"build": 0,
	"eyes": 0,
	"face": 2,
	"pattern": 0,
}

var DEFAULT_TEXTURES_M = {
	"skin": 0,
	"skin-color": 1,
	"hair": 0,
	"hair-color": 2,
	"outfit": 0,
	"outfit-color-1": 0,
	"outfit-color-2": 0,
	"build": 2,
	"eyes": 2,
	"face": 3,
	"pattern": 0,
}

var DEFAULT_TEXTURES_NB = {
	"skin": 0,
	"skin-color": 1,
	"hair": 1,
	"hair-color": 1,
	"outfit": 2,
	"outfit-color-1": 3,
	"outfit-color-2": 3,
	"build": 1,
	"eyes": 1,
	"face": 0,
	"pattern": 0,
}

var texture_settings = {
	"skin": 0,
	"skin-color": 1,
	"hair": 0,
	"hair-color": 2,
	"outfit": 0,
	"outfit-color-1": 0,
	"outfit-color-2": 0,
	"build": 1,
	"eyes": 0,
	"face": 0,
	"pattern": 0,
}
	
var N_PATTERNS = 3
var TEXTURES = {
	"skin-color": [
		"#b47a50",
		"#945a30",
		"#904a37",
		"#9a6050",
		"#cf8583",
		"#dfa5a3",
		"#ffc0a3",
	],
	"hair-color": [
		"#21222b",
		"#01323b",
		"#42111b",
		"#b75a1b",
		"#b77a3b",
		"#bc9f70",
		"#eccf70",
		"#47280e",
	],
	"outfit-color-1": [
		"#666602", # olive
		"#76962b", # spring
		"#405e33", # forest
		"#288750", # mint
		"#589286", # robin's egg
		"#2b4286", # periwinkle
		"#6b8296", # cloudy skies
		"#604f84", # lilac
		"#68373d", # blueberry juice
		"#902d1d", # fire engine
		"#5f260d", # dark leather
		"#4f361d", # light leather
		"#303030", # "black"
		"#505050", # grey
		"#cccccc", # white
	],
	"outfit-color-2": [
		"#969622", # olive
		"#a6c65b", # spring
		"#708e63", # forest
		"#58a780", # mint
		"#88c2b6", # robin's egg
		"#5b72a6", # periwinkle
		"#9bb2c6", # cloudy skies
		"#907fb4", # lilac
		"#98676d", # blueberry juice
		"#c05d4d", # fire engine
		"#8f563d", # dark leather
		"#7f664d", # light leather
		"#505050", # "black"
		"#808080", # grey
		"#ffffff", # white
	],
	"build": [ Vector2(0.9, 1), Vector2(1, 1), Vector2(1.2, 1.04)],
	"eyes": [
		[
			preload("res://assets/character/profile/round-eyes-neutral.png"),
			preload("res://assets/character/profile/round-eyes-sad.png"),
			preload("res://assets/character/profile/round-eyes-happy.png"),
			preload("res://assets/character/profile/round-eyes-angry.png"),
		],
		[
			preload("res://assets/character/profile/small-eyes-neutral.png"),
			preload("res://assets/character/profile/small-eyes-sad.png"),
			preload("res://assets/character/profile/small-eyes-happy.png"),
			preload("res://assets/character/profile/small-eyes-angry.png"),
		],
		[
			preload("res://assets/character/profile/square-eyes-neutral.png"),
			preload("res://assets/character/profile/square-eyes-sad.png"),
			preload("res://assets/character/profile/square-eyes-happy.png"),
			preload("res://assets/character/profile/square-eyes-angry.png"),
		]
	],
	"face": [
		[preload("res://assets/character/profile/face-pronounced.png")],
		[preload("res://assets/character/profile/face-round.png")],
		[preload("res://assets/character/profile/face-thin.png")],
		[preload("res://assets/character/profile/face-square.png")],
	],
	"hair": [
		[
			null,
			preload("res://assets/character/hair/v1/locks-long/front/full.png"),
			preload("res://assets/character/profile/locks.png"),
			preload("res://assets/character/profile/locks-front.png"),
		],
		[
			preload("res://assets/character/hair/v1/long-back-bun/back/full.png"),
			preload("res://assets/character/hair/v1/long-back-bun/front/full.png"),
			preload("res://assets/character/profile/long-bun.png"),
			preload("res://assets/character/profile/long-bun-front.png"),
		],
		[
			null,
			preload("res://assets/character/hair/v1/long-braid/front/full.png"),
			preload("res://assets/character/profile/long-braid.png"),
			preload("res://assets/character/profile/long-braid-front.png"),
		],
		[
			null,
			preload("res://assets/character/hair/v1/short-braid/front/full.png"),
			preload("res://assets/character/profile/short-braid.png"),
			preload("res://assets/character/profile/short-braid-front.png"),
		],
	],
	"skin": [
		[
			preload("res://assets/character/body/v1/body-shade-1.png"),
			preload("res://assets/character/body/v1/front-arm-shade-1.png"),
			preload("res://assets/character/body/v1/face-shade-1.png"),
		],
	],
	"outfit": [
		[
			preload("res://assets/character/clothes/v1/ruana/full/full.png"),
			preload("res://assets/character/clothes/v1/ruana/front/full.png"),
			preload("res://assets/character/clothes/v1/ruana/full/accent.png"),
			preload("res://assets/character/clothes/v1/ruana/front/accent.png"),
			preload("res://assets/character/clothes/v1/ruana/pattern/check.png"),
			preload("res://assets/character/clothes/v1/ruana/pattern/tartan.png"),
			preload("res://assets/character/clothes/v1/ruana/pattern/maze.png"),
		],
		[
			preload("res://assets/character/clothes/v1/dress-and-coat/full/full.png"),
			preload("res://assets/character/clothes/v1/dress-and-coat/front/full.png"),
			preload("res://assets/character/clothes/v1/dress-and-coat/full/accent.png"),
			preload("res://assets/character/clothes/v1/dress-and-coat/front/accent.png"),
			preload("res://assets/character/clothes/v1/dress-and-coat/pattern/check.png"),
			preload("res://assets/character/clothes/v1/dress-and-coat/pattern/tartan.png"),
			preload("res://assets/character/clothes/v1/dress-and-coat/pattern/maze.png"),
		],
		[
			preload("res://assets/character/clothes/v1/side-cape/full/full.png"),
			preload("res://assets/character/clothes/v1/side-cape/front/full.png"),
			preload("res://assets/character/clothes/v1/side-cape/full/accent.png"),
			preload("res://assets/character/clothes/v1/side-cape/front/accent.png"),
			preload("res://assets/character/clothes/v1/side-cape/pattern/check.png"),
			preload("res://assets/character/clothes/v1/side-cape/pattern/tartan.png"),
			preload("res://assets/character/clothes/v1/side-cape/pattern/maze.png"),
		],
		[
			preload("res://assets/character/clothes/v1/chiton/full/full-shaded-shoes.png"),
			preload("res://assets/character/clothes/v1/chiton/front/full.png"),
			preload("res://assets/character/clothes/v1/chiton/full/accent.png"),
			preload("res://assets/character/clothes/v1/chiton/front/accent.png"),
			preload("res://assets/character/clothes/v1/chiton/pattern/check.png"),
			preload("res://assets/character/clothes/v1/chiton/pattern/tartan.png"),
			preload("res://assets/character/clothes/v1/chiton/pattern/maze.png"),
		],
		[
			preload("res://assets/character/clothes/v1/greatkilt/full/full-shaded-shoes.png"),
			preload("res://assets/character/clothes/v1/greatkilt/front/full.png"),
			preload("res://assets/character/clothes/v1/greatkilt/full/accent.png"),
			preload("res://assets/character/clothes/v1/greatkilt/front/accent.png"),
			preload("res://assets/character/clothes/v1/greatkilt/pattern/check.png"),
			preload("res://assets/character/clothes/v1/greatkilt/pattern/tartan.png"),
			preload("res://assets/character/clothes/v1/greatkilt/pattern/maze.png"),
		],
	],
	"pattern": [],
}

func _show_expression(i):
	var ix = texture_settings["eyes"]
	var texture_set = TEXTURES["eyes"]
	var expressions = texture_set[ix]
	
	if profile_features != null:
		profile_features.set_texture(expressions[i])

func frown():
	_show_expression(1)

func smile():
	_show_expression(2)

func scowl():
	_show_expression(3)

func neutral():
	_show_expression(0)


func _refresh_texture_element(key, nodes):
	var ix = texture_settings[key]
	var texture_set = TEXTURES[key]
	var data = texture_set[ix]
	var i = 0
	while i < nodes.size():
		if nodes[i] == null:
			i += 1
			continue
		nodes[i].set_texture(data[i])
		i += 1

func _update_pattern_options():
	var outfit_ix = texture_settings["outfit"]
	var options = TEXTURES["outfit"][outfit_ix].slice(-1 * N_PATTERNS)
	TEXTURES["pattern"] = options
	TEXTURES["pattern"].push_front(null)

func _refresh_pattern():
	_update_pattern_options()
	if not clothes_pattern:
		return
	var ix = texture_settings["pattern"]
	clothes_pattern.set_texture(TEXTURES["pattern"][ix])

func _refresh_color_element(key, nodes):
	var color = TEXTURES[key][texture_settings[key]]
	for node in nodes:
		if node == null:
			continue
		node.modulate = color
		pass
	

func _refresh_skin():
	_refresh_texture_element(
		"skin",
		[
			body,
			front_arm,
			face,
		]
	)
	_refresh_color_element(
		"skin-color",
		[
			face,
			body,
			front_arm,
			profile_head,
			profile_face,
		]
	)

func _refresh_hair():
	_refresh_texture_element(
		"hair",
		[
			hair_back,
			hair_front,
			profile_hair,
			profile_hair_front
		]
	)
	_refresh_color_element(
		"hair-color",
		[
			hair_front,
			profile_hair,
			profile_hair_front
		]
	)
	
func _refresh_outfit():
	_refresh_texture_element(
		"outfit",
		[
			clothes,
			front_sleeve,
			clothes_accent,
			front_sleeve_accent,
		]
	)
	_refresh_pattern()
	_refresh_color_element(
		"outfit-color-1",
		[
			front_sleeve,
			clothes,
			profile_shirt,
		]
	)
	_refresh_color_element(
		"outfit-color-2",
		[
			front_sleeve_accent,
			clothes_accent,
		]
	)

func _refresh_eyes():
	_refresh_texture_element(
		"eyes",
		[
			profile_features
		]
	)

func _refresh_face():
	_refresh_texture_element(
		"face",
		[
			profile_face,
		]
	)
	
func _refresh_build():
	$Character.scale = TEXTURES["build"][texture_settings["build"]]

func _next_texture(key):
	texture_settings[key] = (texture_settings[key] + 1) % TEXTURES[key].size()
	texture_updated()

func next_skin():
	_next_texture("skin")

func next_hair():
	_next_texture("hair")

func next_outfit():
	_next_texture("outfit")

func next_outfit_pattern():
	_next_texture("pattern")

func next_build():
	_next_texture("build")

func next_face():
	_next_texture("face")

func next_eyes():
	_next_texture("eyes")

func next_hair_color():
	_next_texture("hair-color")

func set_hair_color(ix):
	texture_settings["hair-color"] = ix
	texture_updated()
	
func next_skin_color():
	_next_texture("skin-color")

func set_skin(ix):
	texture_settings["skin-color"] = ix
	texture_updated()

func next_outfit_color():
	_next_texture("outfit-color-1")

func next_accent_color():
	_next_texture("outfit-color-2")

func set_outfit_color(ix):
	texture_settings["outfit-color-1"] = ix
	texture_updated()

func set_accent_color(ix):
	texture_settings["outfit-color-2"] = ix
	texture_updated()

func texture_updated():
#	for key in texture_settings.keys():
#		texture_settings[key] = texture_settings[key] % TEXTURES[key].size()
	_refresh_skin()
	_refresh_hair()
	_refresh_outfit()
	_refresh_build()
	_refresh_face()
	_refresh_eyes()
	_save_texture()

func _set_texture_from_save():
	if not game:
		return
	var loaded = game.get_state(["character", "texture"])
	if loaded == null:
		return
	texture_settings = loaded.duplicate()

func _save_texture():
	pass

func load_texture():
	_set_texture_from_save()
	texture_updated()
	return texture_settings

func _ready():
	game = $"/root".get_node_or_null("Game")
	if game:
		world = game.get_node_or_null("MainScreen/World")
	$Character.texture = character_img.get_texture()
	$Character.hframes = hframes
	$Character.vframes = vframes
	if $Character.hframes == 6 and $Character.vframes == 4:
		_make_walk_animations()
	_set_texture_from_save()
	texture_updated()
	if anchor_bottom:
		$Character.offset.y = (($Character.texture.get_height() / $Character.vframes) * -0.5) + 20

func _make_walk_animations():
	var library = AnimationLibrary.new()
	
	for key in ANIMATIONS.keys():
		var value = ANIMATIONS[key]		
		library.add_animation(key, _animation_from_frames(value))

	$AnimationPlayer.add_animation_library("movement", library)

func _animation_from_frames(frames_sequence):
	var animation = Animation.new()
	animation.length = frame_spacing * frames_sequence.size()
	animation.loop_mode = Animation.LOOP_LINEAR
	var track_index = animation.add_track(Animation.TYPE_VALUE)
	animation.track_set_path(track_index, "Character:frame")
	animation.track_set_interpolation_type(track_index, Animation.INTERPOLATION_NEAREST)
	
	var trace = 0
	
	for cur_frame in frames_sequence:
		animation.track_insert_key(track_index, trace, cur_frame)
		trace += frame_spacing

	return animation	
