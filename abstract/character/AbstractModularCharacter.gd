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

var animations_loading = true

@export var frame_spacing: float = 0.3

var SkinAndHairData = preload("res://abstract/character/skin_and_hair_data.tscn").instantiate()
var OutfitColor1 = preload("res://abstract/character/outfit_color_1.tscn").instantiate()
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
	"kneel": [24],
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

func play(animation_title, custom_speed=1.0):
	if animations_loading:
		return
	$AnimationPlayer.play("movement/" + animation_title, -1, custom_speed)

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
	"skin-color": SkinAndHairData.SKIN_COLOURS,
	"skin-color-scene": SkinAndHairData.SKIN_COLOURS_SCENE,
	"hair-color": SkinAndHairData.HAIR_COLOURS,
	"hair-color-scene": SkinAndHairData.HAIR_COLOURS_SCENE,
	"outfit-color-1": OutfitColor1.OPTIONS,
	"outfit-color-1-scene": OutfitColor1.OPTIONS_SCENE,
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
	"outfit-color-2-scene": [
		"#b2b13f", # olive
		"#c2e275", # spring
		"#8aa87c", # forest
		"#73c39a", # mint
		"#a9e4d7", # robin's egg
		"#758bc1", # periwinkle
		"#b6cde2", # cloudy skies
		"#ab99d0", # lilac
		"#b38086", # blueberry juice
		"#de7765", # fire engine
		"#ab6f55", # dark leather
		"#997f65", # light leather
		"#686868", # "black"
		"#9a9a9a", # grey
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
			preload("res://assets/character/body/v1_1/body.png"),
			preload("res://assets/character/body/v1_1/front-arm.png"),
			preload("res://assets/character/body/v1/face-shade-1.png"),
		],
	],
	"outfit": [
		[
			preload("res://assets/character/clothes/v1_1/ruana/full.png"),
			preload("res://assets/character/clothes/v1_1/ruana/front-full.png"),
			preload("res://assets/character/clothes/v1_1/ruana/accent.png"),
			preload("res://assets/character/clothes/v1_1/ruana/front-accent.png"),
			preload("res://assets/character/clothes/v1_1/ruana/check.png"),
			preload("res://assets/character/clothes/v1_1/ruana/tartan.png"),
			preload("res://assets/character/clothes/v1_1/ruana/maze.png"),
		],
		[
			preload("res://assets/character/clothes/v1_1/dress-and-coat/full.png"),
			preload("res://assets/character/clothes/v1_1/dress-and-coat/front-full.png"),
			preload("res://assets/character/clothes/v1_1/dress-and-coat/accent.png"),
			preload("res://assets/character/clothes/v1_1/dress-and-coat/front-accent.png"),
			preload("res://assets/character/clothes/v1_1/dress-and-coat/check.png"),
			preload("res://assets/character/clothes/v1_1/dress-and-coat/tartan.png"),
			preload("res://assets/character/clothes/v1_1/dress-and-coat/maze.png"),
		],
		[
			preload("res://assets/character/clothes/v1_1/side-cape/full.png"),
			preload("res://assets/character/clothes/v1_1/side-cape/front-full.png"),
			preload("res://assets/character/clothes/v1_1/side-cape/accent.png"),
			preload("res://assets/character/clothes/v1_1/side-cape/front-accent.png"),
			preload("res://assets/character/clothes/v1_1/side-cape/check.png"),
			preload("res://assets/character/clothes/v1_1/side-cape/tartan.png"),
			preload("res://assets/character/clothes/v1_1/side-cape/maze.png"),
		],
		[
			preload("res://assets/character/clothes/v1_1/chiton/full.png"),
			preload("res://assets/character/clothes/v1_1/chiton/front-full.png"),
			preload("res://assets/character/clothes/v1_1/chiton/accent.png"),
			preload("res://assets/character/clothes/v1_1/chiton/front-accent.png"),
			preload("res://assets/character/clothes/v1_1/chiton/check.png"),
			preload("res://assets/character/clothes/v1_1/chiton/tartan.png"),
			preload("res://assets/character/clothes/v1_1/chiton/maze.png"),
		],
		[
			preload("res://assets/character/clothes/v1_1/greatkilt/full.png"),
			preload("res://assets/character/clothes/v1_1/greatkilt/front-full.png"),
			preload("res://assets/character/clothes/v1_1/greatkilt/accent.png"),
			preload("res://assets/character/clothes/v1_1/greatkilt/front-accent.png"),
			preload("res://assets/character/clothes/v1_1/greatkilt/check.png"),
			preload("res://assets/character/clothes/v1_1/greatkilt/tartan.png"),
			preload("res://assets/character/clothes/v1_1/greatkilt/maze.png"),
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

func _refresh_color_element(wkey, rkey, nodes):
	var color = TEXTURES[rkey][texture_settings[wkey]]
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
		"skin-color",
		[
			profile_head,
			profile_face,
		]
	)
	_refresh_color_element(
		"skin-color",
		"skin-color-scene",
		[
			face,
			body,
			front_arm,
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
		"hair-color-scene",
		[
			hair_back,
			hair_front,
		]
	)
	_refresh_color_element(
		"hair-color",
		"hair-color",
		[
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
		"outfit-color-1-scene",
		[
			front_sleeve,
			clothes,
		]
	)
	_refresh_color_element(
		"outfit-color-1",
		"outfit-color-1",
		[
			profile_shirt,
		]
	)
	_refresh_color_element(
		"outfit-color-2",
		"outfit-color-2-scene",
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

func set_eyes(ix):
	texture_settings["eyes"] = ix
	texture_updated()

func set_face(ix):
	texture_settings["face"] = ix
	texture_updated()

func next_hair():
	_next_texture("hair")

func set_hair(ix):
	texture_settings["hair"] = ix
	texture_updated()

func next_outfit():
	_next_texture("outfit")

func set_outfit(ix):
	texture_settings["outfit"] = ix
	texture_updated()

func next_outfit_pattern():
	_next_texture("pattern")

func set_outfit_pattern(ix):
	texture_settings["pattern"] = ix
	texture_updated()

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

func set_build(ix):
	texture_settings["build"] = ix
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

func animate_at_mul(mul):
	#frame_spacing = frame_spacing / mul
	#_make_walk_animations()
	pass

func _ready():
	game = $"/root".get_node_or_null("Game")
	if game:
		world = game.get_node_or_null("MainScreen/World")
	$Character.texture = character_img.get_texture()
	$Character.hframes = hframes
	$Character.vframes = vframes
	if $Character.hframes == 6 and $Character.vframes == 5:
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
	animations_loading = false

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
