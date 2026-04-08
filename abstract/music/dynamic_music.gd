extends Node
var current_music: AudioStreamPlayer = null
var next_music: AudioStreamPlayer = null
var old_music = []
var music_stack = []
@export var music_crossfade_speed = 2


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _purge_old_music():
	old_music = old_music.filter(g._not_null)
	for music in old_music:
		if not music.playing and not music in music_stack:
			music.call_deferred("free")

func push_music(n: AudioStreamPlayer):
	music_stack.push_back(current_music)
	play_music(n)

func pop_music(t: AudioStreamPlayer=null):
	if t:
		if t.stream.resource_path != current_music.stream.resource_path:
			print("mismatch!")
			music_stack = music_stack.filter(func (m): return m != t)
			return null

	if not music_stack.size():
		return null
	var n = music_stack.pop_back()
	play_music(n)
	return n

func play_root_music(n: AudioStreamPlayer):
	music_stack.clear()
	play_music(n)

func play_music(n: AudioStreamPlayer, fade_slow=false, scale=music_crossfade_speed, softstart=false):
	next_music = n.duplicate()
	add_child(next_music)
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
	
func buffer():
	_purge_old_music()

