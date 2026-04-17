extends Window
class_name Game

var context = null

var world: Node = null
var cur_modal = null
var player = null
var chapter

var show_clock = true

var moves = 0

signal check_party

@export var cheat_mode = true
@export var cheat_event_trigger_name = ""
@export var cheat_timer_turns = 2

@onready var action_emitter = $ActionEmitter

var MainScreen = preload("res://ui/main_screen.tscn")
var StartScreen = preload("res://ui/start_screen.tscn")

var staged_action_node = null

var characters_present = []
var context_notification = ""
var context_notification_count = 0
var debounce_notifications = false

@export var short_circuit_cutscene: Resource

var StandardBgTextureCalculator = preload("res://ui/standard_bg_texture_calculator.tscn")

var standard_bg_path
var standard_bg
var standard_bg_texture



var CHAPTERS = {
	#"intro": preload("res://intro-story/intro_story_chapter.tscn"),
	"create": preload("res://abstract/character/character_creator.tscn"),
}
@export var FIRST_CHAPTER = "demo1"



func add_character(c):
	characters_present.push_back(c.id)

func change_name_of(c_id, new_name):
	set_state([c_id, "name"], new_name)

func remove_character(c):
	var ix = characters_present.find(c.id)
	characters_present.remove_at(ix)

func unstage_action_node(n):
	if staged_action_node == n:
		staged_action_node = null

func refresh_data():
	var screen = get_node_or_null("MainScreen")
	if screen != null:
		screen.get_node("RightMenu/GameMenu").refresh_data()

func set_player(some_player):
	player = some_player

func reload():
	load_position()
	status.dying = false
	#respawn_player()

func start_from_state(s):
	var screen = MainScreen.instantiate()
	screen.position = Vector2(0, 0)
	$".".add_child(screen)
	chapter = state.start(s)
	chapter.name = "Chapter"
	$".".add_child(chapter)
	load_position()

func load_travel():
	var active_travel = loc.get_travel()
	if not active_travel["is_active"]:
		return false
	chapter.load_travel_stretch(active_travel)
	return true

func get_state(p):
	state.get_state(p)

func set_state(p, v):
	state.set_state(p, v)

func load_position():
	if load_travel():
		return
	var p = get_state(["position"])
	p = p if p else {"scene_path": null}
	if p != null and p["scene_path"] != null:
		loc.load_position(p)
	elif "x" in p and "y" in p and player != null:
		player.position.x = p.x
		player.position.y = p.y


func load_display():
	for m in get_active_player_display_modes():
		player.call(m)
	
func main_menu():
	var s = StartScreen.instantiate()
	add_child(s)
	
	var m = get_node_or_null("MainScreen")
	
	if m != null:
		m.queue_free()
		
	var c = get_node_or_null("Chapter")
	
	if c != null:
		c.queue_free()
	
	state.reset_state()


func to_chapter(_name):
	set_state(["chapter"], _name)
	set_state(["position", "entrance_name"], null)
	var ch = state.load_chapter()
	if $Chapter:
		$Chapter.queue_free()
	set_state(["micro_progress"], {})
	await get_tree().create_timer(0.3).timeout
	ch.name = "Chapter"
	$".".add_child(ch)
	chapter = ch

func save():
	state.save()

func start_new():
	state.deep_init_state()
	start_from_state(state.STATE)
	$ThemeFader.play("fadeout", -1, music.music_crossfade_speed)


func new_from_chapter(start_at: String):
	state.start_from_chapter(start_at)
	start_from_state(state.STATE)
	$ThemeFader.play("fadeout", -1, music.music_crossfade_speed)


func get_start():
	var ch = get_state(["start_from"])
	if ch == null:
		return FIRST_CHAPTER
	return ch
	

func load_game(f):
	var state = JSON.parse_string(f.get_as_text())
	start_from_state(state)
	$ThemeFader.play("fadeout")

# Called when the node enters the scene tree for the first time.
func _get_world():
	if world == null:
		world = $"MainScreen/World"
	return world

func get_world():
	return _get_world()

func _ready():
	world = get_node_or_null("MainScreen/World")

	if short_circuit_cutscene != null:
		#$Blackout.visible = true
		start_new()
		$Chapter.cutscene.page.leave()
		#$Chapter.end_cutscene()
		$Chapter.start_cutscene(short_circuit_cutscene)


func handle_input(delta):
	if status.handle_paused():
		return
	_handle_walk_input(delta)


func _mouse_in_world():
	var w = _get_world()
	if w == null:
		return true
	var mouse = get_mouse_position()
	if mouse.x > w.size.x - 20:
		return false
	if mouse.y > w.size.y:
		return false
	return true


func _handle_walk_input(delta):
	if player == null:
		return
	
	if status.dying:
		player.velocity = Vector2(0, 0)
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
	music.buffer()

func add_modal(some_modal):
	if cur_modal == some_modal:
		return
	if cur_modal != null:
		cur_modal.close()

	cur_modal = some_modal

func remove_modal(some_modal):
	if cur_modal == some_modal:
		cur_modal = null

func respawn_player():
	var data = get_state(["position"])
	
	var scene = $"MainScreen/World".get_child(0).get_node("YSort")
	if scene == null:
		return
	
	var p = Vector2(500, 500)
	if data.entrance_name != null:
		p = scene.get_node(data.entrance_name).position
	elif "x" in data and "y" in data:
		p = Vector2(data.x, data.y)
	else:
		p = scene.get_node("DefaultSpawner").position
	
	player.position = p

func free_world():
	for c in world.get_children():
		c.call_deferred("free")

func set_player_display_modes(mode_names: Array):
	return set_state(["micro_progress", "player_display_modes"], mode_names)
	
func live_change_player_mode(mode_names: Array):
	set_player_display_modes(mode_names)
	if player != null:
		player.respawn()

func get_active_player_display_modes():
	var modes = get_state(["micro_progress", "player_display_modes"])
	if modes == null:
		return []
	return modes
	
func to_map():
	chapter.to_map()

func get_character_dialogue(char_id):
	return chapter.get_character_dialogue(char_id)

func get_scene():
	var c = world.get_children()
	if c.size() == 0:
		return null
	return c[0]

func _refresh_standard_bg_texture():
	if standard_bg != null:
		standard_bg.free()
	standard_bg = StandardBgTextureCalculator.instantiate()
	add_child(standard_bg)
	
	var sc = load(standard_bg_path)
	var bg = sc.instantiate()
	bg.as_background = true
	bg.position = Vector2(0, 0)
	
	standard_bg.add_child(bg)
	standard_bg_texture = standard_bg.get_texture()


func get_standard_bg():
	var path = chapter.cached_scene_path
	print(path, " ", standard_bg)
	
	if path and path != standard_bg_path:
		standard_bg_path = path
		_refresh_standard_bg_texture()

	var sc = Sprite2D.new()
	sc.centered = false
	sc.texture = standard_bg_texture
	return sc

func get_standard_bg_scale():
	return chapter.cached_bg_scale

func get_standard_bg_position():
	return chapter.cached_bg_position


func notify(data):
	if debounce_notifications and data == context_notification:
		return
	context_notification = data
	debounce_notifications = true
	context_notification_count = context_notification_count + 1
	await get_tree().create_timer(12).timeout
	debounce_notifications = false

func clear_notification():
	notify("")



func _init_star_rituals_if_needed():
	var data = get_state(["micro_progress", "star_rituals"])
	if data != null:
		return data
	return set_state(["micro_progress", "star_rituals"], [])
	
func check_star_ritual(ritual_id):
	var data = _init_star_rituals_if_needed()
	return ritual_id in data

func win_star_ritual(ritual_id):
	var data = _init_star_rituals_if_needed()
	return set_state(["micro_progress", "star_rituals"], data + [ritual_id])


func set_context(new_ctx: int):
	if new_ctx == context:
		return
	context = new_ctx
	clear_notification()
	
