extends Window

var world = null
var cur_modal = null
var player = null
var chapter
var started = false
var paused = false
var unpausing = false
var leyline_showing = false
var is_scouting = false

var moves = 0

@export var cheat_mode = true
@export var cheat_event_trigger_name = ""
@export var cheat_timer_turns = 2

var MainScreen = preload("res://ui/main_screen.tscn")
var StartScreen = preload("res://ui/start_screen.tscn")
var ConceptMapRes = preload("res://concept-map/concept_map.tscn")

var staged_action_node = null

var current_music: AudioStreamPlayer = null
var next_music: AudioStreamPlayer = null
var old_music = []

var characters_present = []

@export var short_circuit_cutscene: Resource

@export var music_crossfade_speed = 2

var CHAPTERS = {
	"intro": preload("res://intro-story/intro_story_chapter.tscn"),
	"create": preload("res://character/character_creator.tscn"),
	"test0": preload("res://chapters/demo/0/chapter_test.tscn"),
	"demo1": preload("res://chapters/demo/1/demo-industrial.tscn")
}
@export var FIRST_CHAPTER = "demo1"

var INITIAL_STATE = {
	"micro_progress": {
		"events": [],
	},
	"chapter": "intro",
	"story": [],
	"position": {
		"scene_path": null,
		"entrance_name": null,
	},
	"moves": 0,
	"timers": [],
}

var STATE = INITIAL_STATE.duplicate(true)

func get_state_default(ix):
	return _get_state(ix, {
		"taylor": {
			"calls_me": get_state(["character", "name", "elves_call"], false)
		}
	})

func add_character(c):
	characters_present.push_back(c.id)

func name_of(c_id):
	var data = get_state([c_id, "name"])
	if data != null:
		return data
	var concept = $ConceptMap.get_concept(c_id)
	if concept == null:
		return null
	return concept.title

func change_name_of(c_id, new_name):
	set_state([c_id, "name"], new_name)

func remove_character(c):
	var ix = characters_present.find(c.id)
	characters_present.remove_at(ix)

func play_music(n: AudioStreamPlayer, fade_slow=false, scale=music_crossfade_speed, softstart=false):
	next_music = n.duplicate()
	$DynamicMusic.add_child(next_music)
	if current_music != null:
		if current_music.get_node("Fader") != null:
			current_music.get_node("Fader").play("fadeout", -1, scale)
		else:
			current_music.playing = false
	if next_music.get_node("Fader") != null:
		if softstart:
			next_music.get_node("Fader").play("softstart", -1, scale)
		elif fade_slow:
			next_music.get_node("Fader").play("fadein", -1, scale)
		else:
			next_music.get_node("Fader").play("faston", -1, scale)
	else:
		next_music.playing = true
	old_music.push_back(current_music)
	current_music = next_music

func fade_music_out():
	if current_music == null:
		return
	current_music.get_node("Fader").play("fadeout", -1, music_crossfade_speed)
	old_music.push_back(current_music)
	current_music = null
	

func _not_null(item):
	if item == null:
		return false
	return true

func _purge_old_music():
	old_music = old_music.filter(_not_null)
	for music in old_music:
		if not music.playing:
			music.call_deferred("free")

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

func get_state(ix, defaults=true):
	var data = _get_state(ix, STATE)
	if data == null and defaults:
		return get_state_default(ix)
	return data

func _deep_set(d, ix, val):
	if not ix[0] in d:
		d[ix[0]] = {}
	if ix.size() == 1:
		d[ix[0]] = val
		return
	_deep_set(d[ix[0]], ix.slice(1), val)

func set_state(ix, val):
	_deep_set(STATE, ix, val)
	return val

func set_state_push_to_key(ix, val):
	var cur = get_state(ix)
	if cur == null:
		set_state(ix, [val])
		return
	set_state(ix, cur + [val])


func set_player(some_player):
	player = some_player


func start_from_state(s):
	STATE = s	#screen.get_node("World").add_child(ch)

	var screen = MainScreen.instantiate()
	screen.position = Vector2(0, 0)
	$".".add_child(screen)

	var ch = CHAPTERS[STATE["chapter"]].instantiate()
	ch.name = "Chapter"
	chapter = ch
	$".".add_child(ch)
	
	var p = get_state(["position"])
	if p != null and p["scene_path"] != null:
		$Map.load_position(p)
	
	load_quests()
	
	started = true
	
func main_menu():
	var s = StartScreen.instantiate()
	add_child(s)
	
	$ConceptMap.free()
	var new_map = ConceptMapRes.instantiate()
	add_child(new_map)
	
	var m = get_node_or_null("MainScreen")
	
	if m != null:
		m.queue_free()
		
	var c = get_node_or_null("Chapter")
	
	if c != null:
		c.queue_free()
	
	reset_state()
	
	

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

func reset_state():
	STATE = INITIAL_STATE.duplicate(true)

func start_new():
	start_from_state(STATE)
	$ThemeFader.play("fadeout", -1, music_crossfade_speed)

func load_game(f):
	var state = JSON.parse_string(f.get_as_text())
	start_from_state(state)
	$ThemeFader.play("fadeout")

# Called when the node enters the scene tree for the first time.
func _get_world():
	if world == null:
		world = $"MainScreen/World"
	return world

func _ready():
	world = get_node_or_null("MainScreen/World")

	if short_circuit_cutscene != null:
		$Blackout.visible = true
		start_new()
		$Chapter.cutscene.page.leave()
		#$Chapter.end_cutscene()
		$Chapter.start_cutscene(short_circuit_cutscene)


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
	var w = _get_world()
	if w == null:
		return true
	var mouse = get_mouse_position()
	if mouse.x > w.size.x - 20:
		return false
	if mouse.y > w.size.y:
		return false
	return true

func leyline():
	if chapter != null and chapter.cutscene != null:
		return
	if not leyline_showing and $Map != null and $Map.current != null:
		$Map.current.leyline()

func scout():
	if is_scouting or chapter != null and chapter.cutscene != null:
		return
	is_scouting = true
	await get_tree().create_timer(3.0).timeout
	is_scouting = false

func _cheat_event():
	$Chapter.trigger(cheat_event_trigger_name)
	
func _cheat_set_timer():
	add_timer(cheat_timer_turns, cheat_event_trigger_name)

func _handle_walk_input(delta):
	if player == null:
		return

	var arrow_keys = Input.get_vector("left", "right", "up", "down")
	var click = Input.is_action_just_released("click")
	var ley = Input.is_action_just_released("leyline")
	var cheat_event = Input.is_action_just_pressed("cheat event")
	var cheat_timer = Input.is_action_just_pressed("cheat timer")
	if cheat_event and cheat_mode:
		_cheat_event()
	elif cheat_timer and cheat_mode:
		_cheat_set_timer()

	if click and _mouse_in_world():
		player.destination_clicked(delta)
		return
	
	if ley:
		leyline()

	if arrow_keys.x != 0 or arrow_keys.y != 0:
		player.arrow_keys_pressed(delta, arrow_keys)
		return
	
	player.no_input()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	handle_input(delta)
	_purge_old_music()

func add_modal(some_modal):
	if cur_modal == some_modal:
		return
	if cur_modal != null:
		cur_modal.close()

	cur_modal = some_modal

func remove_modal(some_modal):
	if cur_modal == some_modal:
		cur_modal = null

func save_position(scene_path, entrance_name=null):
	set_state(
		["position"],
		{"scene_path": scene_path, "entrance_name": entrance_name}
	)

func load_quests():
	_init_quests_if_needed()
	var quests = get_state(["quests", "active"])
	for ix in quests:
		var quest = $QuestMap.get_quest(ix)
		if quest != null:
			quest.resume()

func _init_quests_if_needed():
	var q = get_state(["quests"])
	if q != null:
		return
	set_state(
		["quests"],
		{"active": [], "complete": []},
	)

func init_inventory_if_needed():
	var inv = get_state(["inventory"])
	if inv != null:
		return
	set_state(["inventory"], [])
	#set_state(["inventory"], ["pcb", "wire", "board", "car-keys", "alternator"])

	
func _init_party_if_needed():
	var q = get_state(["party"])
	if q != null:
		return
	set_state(
		["party"],
		[""],
	)

func start_quest(quest):
	_init_quests_if_needed()
	set_state_push_to_key(["quests", "active"], quest.id)

func complete_quest(quest):
	var active_quests = get_state(["quests", "active"])
	active_quests = active_quests.filter(func(q): return q != quest.id)
	set_state(["quests", "active"], active_quests)
	set_state_push_to_key(["quests", "complete"], quest.id)

func get_active_quests():
	_init_quests_if_needed()
	return get_state(["quests", "active"])

func is_quest_active(quest):
	_init_quests_if_needed()
	return quest.id in get_state(["quests", "active"])

func get_followers_from_state():
	_init_party_if_needed()
	return get_state(["party"])

func check_state_for_follower(npc):
	_init_party_if_needed()
	var followers = get_state(["party"])
	return npc.id in followers

func remove_inventory_item(item):
	init_inventory_if_needed()
	var new_inventory = get_state(["inventory"]).filter(func(i): return i != item.id)
	set_state(["inventory"], new_inventory)

func add_inventory_item(item):
	init_inventory_if_needed()
	set_state_push_to_key(["inventory"], item.id)

func inventory_contains(item_id):
	init_inventory_if_needed()
	return item_id in get_state(["inventory"])

func init_resolutions_if_needed():
	var data = get_state(["resolutions"])
	if data != null:
		return data
	return set_state(["resolutions"], [])

func add_resolution(resolution_id):
	print(init_resolutions_if_needed(), resolution_id)
	#init_resolutions_if_needed()
	if has_resolution(resolution_id):
		return
	set_state_push_to_key(["resolutions"], resolution_id)

func has_resolution(resolution_id):
	var data = init_resolutions_if_needed()
	print(data)
	return resolution_id in data

func init_reflections_if_needed():
	var data = get_state(["reflections"])
	if data != null:
		return data
	return set_state(["reflections"], [])

func add_reflection(reflection_id):
	init_reflections_if_needed()
	set_state_push_to_key(["reflections"], reflection_id)

func n_reflections():
	return init_reflections_if_needed().size()
	
func resolve_reflection(reflection_id):
	init_reflections_if_needed()
	var data = get_state(["reflections"])
	data = data.filter(func(i): return i != reflection_id)
	set_state(["reflections"], data)

func list_reflections():
	init_reflections_if_needed()
	return get_state(["reflections"])

func _init_moves_if_needed():
	var data = get_state(["moves"])
	if data != null:
		return data
	return set_state(["moves"], 0)

func _init_timers_if_needed():
	var data = get_state(["timers"])
	if data != null:
		return data
	return set_state(["timers"], [])

func add_timer(n, trigger_name):
	var m = _init_moves_if_needed()
	var timers = _init_timers_if_needed()
	set_state(["timers"], timers + [[m + n, trigger_name]])

func check_timers():
	var m = _init_moves_if_needed()
	var timers = _init_timers_if_needed()
	var remaining = []
	for t in timers:
		if t[0] <= m:
			$Chapter.trigger(t[1])
			continue
		remaining.push_back(t)
	set_state(["timers"], remaining)

func move():
	var m = _init_moves_if_needed()
	set_state(["moves"], m + 1)
	check_timers()

func _init_played_cutscenes_if_needed():
	var data = get_state(["played_cutscenes"])
	if data != null:
		return data
	return set_state(["played_cutscenes"], [])


func is_cutscene_section_already_played(section_id):
	var played = _init_played_cutscenes_if_needed()
	return section_id in played

func mark_cutscene_section_played(section_id):
	_init_played_cutscenes_if_needed()
	set_state_push_to_key(["played_cutscenes"], section_id)

func free_world():
	for c in world.get_children():
		c.call_deferred("free")
