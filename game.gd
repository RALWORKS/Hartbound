extends Window

var world = null
var cur_modal = null
var player = null
var chapter
var started = false
var paused = false
var unpausing = false

var MainScreen = preload("res://ui/main_screen.tscn")

var staged_action_node = null

var CHAPTERS = {
	"new": preload("res://character/character_creator.tscn"),
	"test0": preload("res://chapters/demo/0/chapter_test.tscn"),
	"demo1": preload("res://chapters/demo/1/demo-industrial.tscn")
}
@export var FIRST_CHAPTER = "demo1"

var STATE = {
	"micro_progress": {
		"priestess_follows": false,
		"event": 0,
	},
	"chapter": "new",
	"story": [],
}

func unstage_action_node(n):
	if staged_action_node == n:
		staged_action_node = null

func refresh_data():
	var screen = get_node_or_null("MainScreen")
	if screen != null:
		screen.get_node("Menu/GameMenu").refresh_data()

func push_story(title_, narrative):
	STATE["story"].append({
		"title": title_,
		"narrative": narrative
	})

func _get_state(ix, d):
	if not ix[0] in d:
		return null

	if ix.size() == 1:
		return d[ix[0]]

	return _get_state(ix.slice(1), d[ix[0]])

func get_state(ix):
	return _get_state(ix, STATE)

func _deep_set(d, ix, val):
	if not ix[0] in d:
		d[ix[0]] = {}
	if ix.size() == 1:
		d[ix[0]] = val
		return
	_deep_set(d[ix[0]], ix.slice(1), val)

func set_state(ix, val):
	_deep_set(STATE, ix, val)


func set_player(some_player):
	player = some_player


func start_from_state(s):
	STATE = s	#screen.get_node("World").add_child(ch)

	var screen = MainScreen.instantiate()
	screen.position = Vector2(0, 0)
	$".".add_child(screen)

	var ch = CHAPTERS[STATE["chapter"]].instantiate()
	ch.name = "Chapter"
	$".".add_child(ch)
	started = true

func unpause():
	if unpausing:
		return
	unpausing = true
	await get_tree().create_timer(0.3).timeout
	if not unpausing:
		return
	paused = false

func pause():
	paused = true
	unpausing = false

func to_chapter(_name):
	set_state(["chapter"], _name)
	var ch = CHAPTERS[STATE["chapter"]].instantiate()
	if $Chapter:
		$Chapter.queue_free()
	await get_tree().create_timer(0.3).timeout
	ch.name = "Chapter"
	$".".add_child(ch)
	chapter = ch

func _rand_path():
	var rng = RandomNumberGenerator.new()
	return str(rng.randi_range(1000, 9999))

func _clean_name_to_path(n: String):
	var regex = RegEx.new()
	regex.compile("[a-zA-Z]+")
	var result = regex.search_all(n)
	var strings = []
	for r in result:
		for s in r.strings:
			strings.push_back(s)
	var out = "-".join(strings)
	return out + _rand_path()

func _null_or_empty(s):
	return s == null or s.is_empty()

func save():
	if STATE["savefile_name"] and _null_or_empty(get_state(["savefile_path"])):
		STATE["savefile_path"] = _clean_name_to_path(STATE["savefile_name"]) + ".sav"
	elif _null_or_empty(get_state(["savefile_path"])):
		STATE["savefile_path"] = _rand_path() + ".sav"

	var file = FileAccess.open(
		"user://save/" + STATE["savefile_path"],
		FileAccess.WRITE
	)
	var content = JSON.stringify(STATE)
	file.store_string(content)


func start_new():
	start_from_state(STATE)

func load_game(f):
	var state = JSON.parse_string(f.get_as_text())
	start_from_state(state)

# Called when the node enters the scene tree for the first time.
func _ready():
	world = get_node_or_null("MainScreen/World")


func handle_input(delta):
	if not started:
		pause()
		return

	if chapter != null and chapter.cutscene != null:
		pause()
		return

	if cur_modal != null:
		pause()
		return
	
	if player == null:
		return

	if paused:
		unpause()
		return

	_handle_walk_input(delta)


func _mouse_in_world():
	if not world:
		return true
	var mouse = get_mouse_position()
	if mouse.x > world.size.x - 100:
		return false
	if mouse.y > world.size.y:
		return false
	return true


func _handle_walk_input(delta):
	if player == null:
		return

	var arrow_keys = Input.get_vector("left", "right", "up", "down")
	var click = Input.is_action_just_released("click")

	if click and _mouse_in_world():
		player.destination_clicked(delta)
		return

	if arrow_keys.x != 0 or arrow_keys.y != 0:
		player.arrow_keys_pressed(delta, arrow_keys)
		return
	
	player.no_input()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	handle_input(delta)

func add_modal(some_modal):
	if cur_modal == some_modal:
		return
	if cur_modal != null:
		cur_modal.close()

	cur_modal = some_modal

func remove_modal(some_modal):
	if cur_modal == some_modal:
		cur_modal = null
