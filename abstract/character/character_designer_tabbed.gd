extends Node2D

@onready var tabs = $Designer.get_children()

# Called when the node enters the scene tree for the first time.
func _ready():
	refresh()
	setup_clothing()
	setup_face()
	setup_body()
	setup_hair()
	setup_profile()



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func setup_clothing():
	var outfits = $Designer/Clothing/OutfitStyle/Data.get_children()
	for ix in range(outfits.size()):
		outfits[ix].connect("pressed", func (): set_outfit(ix))
	
	var patterns = $Designer/Clothing/Pattern/Data.get_children()
	for ix in range(patterns.size()):
		patterns[ix].connect("pressed", func (): set_outfit_pattern(ix))
	
	make_swatch_array(
		$Designer/Clothing/Colour1/Data,
		$CharacterSpriteDisplay.char_texture_options()["outfit-color-1"],
		["character", "texture", "outfit-color-1"],
		4,
	)
	make_swatch_array(
		$Designer/Clothing/Colour2/Data,
		$CharacterSpriteDisplay.char_texture_options()["outfit-color-2"],
		["character", "texture", "outfit-color-2"],
		4,
	)
	

func setup_face():
	make_swatch_array(
		$Designer/Body/Skin/Data,
		$CharacterSpriteDisplay.char_texture_options()["skin-color"],
		["character", "texture", "skin-color"],
		8,
	)
	var eyes = $Designer/Body/Features/Data.get_children()
	for ix in range(eyes.size()):
		eyes[ix].connect("pressed", func (): set_eyes(ix))
	
	var faces = $Designer/Body/FaceShape/Data.get_children()
	for ix in range(faces.size()):
		faces[ix].connect("pressed", func (): set_face(ix))

func setup_body():
	var builds = $Designer/Body/Build/Data.get_children()
	for ix in range(builds.size()):
		builds[ix].connect("pressed", func (): set_build(ix))

func setup_hair():
	make_swatch_array(
		$Designer/Hair/HairColour/Data,
		$CharacterSpriteDisplay.char_texture_options()["hair-color"],
		["character", "texture", "hair-color"],
		4,
	)
	
	var hairs = $Designer/Hair/HairStyle/Data.get_children()
	for ix in range(hairs.size()):
		hairs[ix].connect("pressed", func (): set_hair(ix))

func setup_profile():
	var shots = $Designer/Portrait/Composition/Data.get_children()
	for ix in range(shots.size()):
		shots[ix].connect("pressed", func (): set_shot(ix))
	
	var patterns = $Designer/Portrait/PortraitBgTexture/Data.get_children()
	for ix in range(patterns.size()):
		patterns[ix].connect("pressed", func (): set_bg_texture(ix))
	
	var bg_color = []
	for c in $Profile.TEXTURES["bg"]:
		bg_color.push_back(c[0])
	make_swatch_array(
		$Designer/Portrait/PortraitBgColour/Data,
		bg_color,
		["profile", "texture", "bg"],
		7,
	)
	
	make_swatch_array(
		$Designer/Portrait/Lighting/Data,
		$Profile.TEXTURES["filter"],
		["profile", "texture", "filter"],
		4,
	)

func set_build(ix):
	$CharacterSpriteDisplay.set_build(ix)
	save()

func direct_state_edit(path, value):
	state.set_state(path, value)
	print("CLICK EDIT STATUE", path, "   ",  value)
	refresh()

func make_swatch_array(target, options, state_path, width):
	var x = 0
	var y = 0
	var ix = 0
	for hex in options:
		var b = Button.new()
		var s = StyleBoxFlat.new()
		s.bg_color = hex
		b.add_theme_stylebox_override("normal", s)
		b.position = Vector2(x * 50, y * 50)
		b.size = Vector2(30, 30)
		b.connect("pressed", func (): direct_state_edit(state_path, ix))
		target.add_child(b)
		x += 1
		ix += 1
		if x >= width:
			x = 0
			y += 1

func set_shot(ix):
	$Profile.set_texture_el("shot", ix)
	save()

func set_eyes(ix):
	$CharacterSpriteDisplay.set_eyes(ix)
	save()

func set_face(ix):
	$CharacterSpriteDisplay.set_face(ix)
	save()

func set_bg_texture(ix):
	$Profile.set_texture_el("bg-texture", ix)
	save()

func set_hair(ix):
	$CharacterSpriteDisplay.set_hair(ix)
	save()

func set_outfit(ix):
	$CharacterSpriteDisplay.set_outfit(ix)
	save()

func set_outfit_pattern(ix):
	$CharacterSpriteDisplay.set_outfit_pattern(ix)
	save()
	
func genderize(gender):
	$Profile.gender_default(gender)

func randomize_features():
	$Profile.shuffle_bg()
	$CharacterSpriteDisplay.randomize_features()
	save()

func save():
	$Profile.save_texture()
	$CharacterSpriteDisplay.save_texture()
	refresh()

func refresh():
	$Profile.refresh()
	$CharacterSpriteDisplay.refresh()
	var g = get_node_or_null("/root/Game")
	if g:
		g.refresh_data()
	
func close_tab(tab: Panel):
	tab.process_mode = Node.PROCESS_MODE_DISABLED
	tab.visible = false

func open_tab(tab: Panel):
	tab.process_mode = Node.PROCESS_MODE_INHERIT
	tab.visible = true

func _on_tab_bar_tab_changed(ix):
	for tab in tabs:
		close_tab(tab)
	open_tab(tabs[ix])


func _on_randomize_all_pressed():
	randomize_features()


func start_daylight_cycle():
	$CharacterSpriteDisplay.start_daylight_cycle()
	$DisplayOptions/LightCycle/CheckButton.toggle_mode = true

func stop_daylight_cycle():
	$CharacterSpriteDisplay.stop_daylight_cycle()
	$DisplayOptions/LightCycle/CheckButton.toggle_mode = false




func _on_light_cycle_toggled(button_pressed):
	$DisplayOptions/LightCycle/CheckButton.set_pressed_no_signal(button_pressed)
	if button_pressed:
		start_daylight_cycle()
	else:
		stop_daylight_cycle()


func _on_rotate_char_toggled(button_pressed):
	$DisplayOptions/RotateChar/CheckButton.set_pressed_no_signal(button_pressed)
	if button_pressed:
		$CharacterSpriteDisplay.start_rotation()
	else:
		$CharacterSpriteDisplay.stop_rotation()
