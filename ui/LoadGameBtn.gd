extends Button

@export var save_directory = "user://save"

func _get_save_directory():
	var dir = DirAccess.open(save_directory)
	if not dir:
		DirAccess.make_dir_absolute(save_directory)
	return save_directory
	


# Called when the node enters the scene tree for the first time.
func _ready():
	_get_save_directory()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func list_games():
	var games = []
	var dir = DirAccess.open(save_directory)
	if not dir:
		print("can't access save directory")
		return []
	dir.list_dir_begin()
	var file_name = dir.get_next()
	while file_name != "":
		if dir.current_is_dir():
			print("Found directory: " + file_name)
		else:
			games.push_back(file_name)
		file_name = dir.get_next()
	return games

func _get_name_from_file(f):
	var file = FileAccess.open(
		save_directory + "/" + f, 
	FileAccess.READ)
	var json = JSON.new()
	var error = json.parse(file.get_as_text())
	if error == OK:
		var data = json.data
		if "savefile_name" in data:
			return (
				data["savefile_name"]
				+ "    (" + f + ")"
			)
	return f
	

func _load_file(f):
	var file = FileAccess.open(
		save_directory + "/" + f, 
	FileAccess.READ)
	$"../..".load_game(file)
	$"..".queue_free()

func _on_pressed():
	for c in $"../LoadGameBtn/ListGames".get_children():
		c.free()
	
	var games = list_games()
	
	if games.size() == 0:
		var msg = RichTextLabel.new()
		msg.push_color("#ffffff")
		
		msg.add_text("No games found")
		msg.size = Vector2(200, 100)

		$"../LoadGameBtn/ListGames".add_child(msg)
		
		disabled = true
		return
	
	var y = 10
	for game in games:
		var btn = Button.new()
		btn.position = Vector2(0, y)
		btn.text = "> " + _get_name_from_file(game)
		btn.pressed.connect(
			func (): _load_file(game)
		)
		$ListGames.add_child(btn)
		y = y + 50
	
	
	#$"../..".start_new()
	#$"..".queue_free()
