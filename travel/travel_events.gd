class_name TravelEvents
extends Node

var EventMap = {}
@onready var segues: AnimationPlayer = $"../EventSegue"

func get_next_event_by_id(id: String):
	setup_event_map()
	var ptr = EventMap[id]
	var next = get_next_event_for_category(ptr)
	if next != null:
		return next
	if ptr.default_if_empty == null:
		return null
	return get_next_event_for_category(ptr.default_if_empty)
	
func get_next_event_for_category(ptr):
	var events_done = get_events_done(ptr)
	print(ptr, events_done, ptr.get_children())
	if ptr.get_child_count() == 0:
		return null
	if events_done.size() == 0:
		return ptr.get_children()[0]
	if events_done[-1] >= ptr.get_child_count() - 1:
		return null
	return ptr.get_children()[events_done[-1] + 1]

func get_events_done(ptr):
	$"/root/Game".init_travel_events_if_needed()
	var data = $"/root/Game".get_state(["micro_progress", "travel_events", ptr.id])
	return data if data != null else []

func setup_event_map():
	for c in get_children():
		EventMap[c.id] = c


func play_turn(event, section):
	$"..".iterate_turn()
	if segues.has_animation(section):
		return play_event_after_segue(event, section)
	event.play()


func play_event_after_segue(event, section):
	segues.connect("animation_finished", func (anim_name): event.play())
	segues.play(section)

func start_talking():
	var big_talk = get_next_event_by_id("talk")
	if big_talk:
		return play_turn(big_talk, "talk")


func start_thinking():
	var big_think = get_next_event_by_id("think")
	if big_think:
		return play_turn(big_think, "think")


# Called when the node enters the scene tree for the first time.
func _ready():
	$"/root/Game".init_travel_events_if_needed()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
