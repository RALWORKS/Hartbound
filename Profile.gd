extends Sprite2D


func _ready():
	_set_texture_from_save()
	texture_updated()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func load_character_texture():
	return $img/Character.load_texture()

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


var TEXTURES = {
	"bg": [
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
		[
			preload("res://assets/character/profile/bg5.png"),
		],
	],
	"filter": [
		"#ffffff",
		"#ffff99",
		"99ffff",
	],
	"shot": [
		[Vector2(1, 1), Vector2(250, 250), 0],
		[Vector2(1.1, 1.1), Vector2(300, 300), 0.05*PI],
		[Vector2(1.1, 1.1), Vector2(300, 250), -0.1*PI],
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
	_next_texture("bg")

func next_filter():
	_next_texture("filter")

func _next_texture(key):
	texture_settings[key] = (texture_settings[key] + 1) % TEXTURES[key].size()
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
	_refresh_texture_element(
		"bg",
		[
			$img/background
		]
	)

func texture_updated():
	_refresh_bg()
	_refresh_filter()
	_refresh_shot()


var texture_settings = {
	"bg": 1,
	"filter": 0,
	"shot": 0,
}

func _refresh_filter():
	$".".self_modulate = TEXTURES["filter"][texture_settings["filter"]]

func _refresh_shot():
	var shot = TEXTURES["shot"][texture_settings["shot"]]
	$img/Character.set_deferred("scale", shot[0])
	$img/Character.set_deferred("position", shot[1])
	$img/Character.set_deferred("rotation", shot[2])
