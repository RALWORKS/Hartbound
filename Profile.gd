extends Sprite2D

@export var with_background = true
@export var start_smile = false
@export var start_scowl = false
@export var start_frown = false

func _ready():
	reload()
	if not with_background:
		texture = $profileImg.get_texture()
	
	if start_smile:
		smile()
	elif start_frown:
		frown()
	elif start_scowl:
		scowl()

func reload():
	_set_texture_from_save()
	texture_updated()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func smile():
	$img/Character.smile()

func frown():
	$img/Character.frown()

func scowl():
	$img/Character.scowl()

func neutral():
	$img/Character.neutral()

func load_character_texture():
	$img/Character.load_texture()

func load_profile_textures():
	_set_texture_from_save()
	return texture_updated()
	
func refresh():
	load_character_texture()
	load_profile_textures()
	
func _set_texture_from_save():
	var game = $"/root".get_node_or_null("Game")
	if not game:
		return
	var loaded = game.get_state(["profile", "texture"])
	if loaded == null:
		return
	texture_settings = loaded.duplicate()
	return texture_settings

func save_texture():
	var game = $"/root".get_node_or_null("Game")
	if not game:
		return
	var CONTROLLED_CHAR_ELEMENTS = ["face", "eyes"]
	for key in CONTROLLED_CHAR_ELEMENTS:
		game.set_state(["character", "texture", key], $img/Character.texture_settings[key])
	game.set_state(["profile", "texture"], texture_settings.duplicate())


var TEXTURES = {
	"bg": [
		[
			# YELLOW
			"#bf8a12",
		],
		[
			# LIME YELLOW
			"#dfdf70",
		],
		[
			# GREEN
			"#0c4b2c",
		],
		[
			# LIGHT BLUE
			"#5c7594",
		],
		[
			# BLUE
			"#2c4564",
		],
		[
			# DARK BLUE
			"#002044",
		],
		[
			# PURPLE
			"#504064",
		],
		[
			# DARK PURPLE
			"#302044",
		],
		[
			# LIGHT RED
			"#cf6b5b",
		],
		[
			# MID RED
			"#800000",
		],
		[
			# DARK RED
			"#400000",
		],
		[
			# ORANGE
			"#bf5a12",
		],
		[
			# DARK ORANGE
			"#501a00",
		],
		[
			# WHITE
			"#c0c0c0",
		],
		[
			# GREY
			"#505050",
		],
		[
			# BLACK
			"#202020",
		],
	],
	"bg-texture": [
		[
			preload("res://assets/character/profile/bg1.png"),
		],
		[
			preload("res://assets/character/profile/bg2.png"),
		],
		[
			preload("res://assets/character/profile/bg3.png"),
		],
		[
			preload("res://assets/character/profile/bg4.png"),
		],
#		[
#			preload("res://assets/character/profile/bg5.png"),
#		],
		[
			preload("res://assets/character/profile/bg6.png"),
		],
	],
	"filter": [
		"#ffffff",
		"#ffff99",
		"99ffff",
	],
	"shot": [
		[Vector2(1, 1), Vector2(250, 550), 0],
		[Vector2(0.8, 0.8), Vector2(220, 500), 0],
		[Vector2(1.2, 1.2), Vector2(300, 600), -(1/36)*PI],
		[Vector2(1, 1), Vector2(310, 550), 0],
	],
}

func next_face():
	$img/Character.next_face()
	texture_updated()

func next_shot():
	_next_texture("shot")

func next_eyes():
	$img/Character.next_eyes()
	texture_updated()

func next_bg():
	_next_texture("bg-texture")

func shuffle_bg():
	texture_settings["bg-texture"] = randi() % TEXTURES["bg-texture"].size()
	texture_settings["bg"] = randi() % TEXTURES["bg"].size()
	texture_updated()
	

func next_filter():
	_next_texture("filter")

func _next_texture(key):
	texture_settings[key] = (texture_settings[key] + 1) % TEXTURES[key].size()
	texture_updated()

func set_texture_el(key, ix):
	texture_settings[key] = ix
	texture_updated()

func _refresh_texture_element(key, nodes):
	var ix = texture_settings[key]
	var texture_set = TEXTURES[key]
	var data = texture_set[ix]
	var i = 0
	while i < nodes.size():
		nodes[i].set_texture(data[i])
		i += 1

func _refresh_color_element(key, nodes):
	var color = TEXTURES[key][texture_settings[key]]
	for node in nodes:
		node.color = color
	

func _refresh_bg():	
	var bg_ix = texture_settings["bg"]
	var color_set = TEXTURES["bg"]
	var color = color_set[bg_ix]
	var texture_ix = texture_settings["bg-texture"]
	var texture_set = TEXTURES["bg-texture"]
	var bg_texture = texture_set[texture_ix]
	$img/background.set_texture(bg_texture[0])
	$img/background.modulate = color[0]

func texture_updated():
	_refresh_bg()
	_refresh_filter()
	_refresh_shot()

func set_bg_color(ix):
	texture_settings["bg"] = ix
	texture_updated()

var texture_settings = {
	"bg": 0,
	"bg-texture": 3,
	"filter": 0,
	"shot": 0,
}

func _refresh_filter():
	if not with_background:
		return
	$img/Character.modulate = TEXTURES["filter"][texture_settings["filter"]]

func _refresh_shot():
	var shot = TEXTURES["shot"][texture_settings["shot"]]
	$img/Character.set_deferred("scale", shot[0])
	$img/Character.set_deferred("position", shot[1])
	$img/Character.set_deferred("rotation", shot[2])
