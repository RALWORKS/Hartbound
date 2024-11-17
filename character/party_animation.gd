extends Node2D

var animation_player: AnimationPlayer
var trigger: Area2D

@export var player_end_position: Vector2
@export var brona_end_position: Vector2
@export var taylor_end_position: Vector2

var party = []

var position_map = {}

var map: Node2D = null
var already = false


# Called when the node enters the scene tree for the first time.
func _ready():
	position_map["player"] = player_end_position
	position_map["brona"] = brona_end_position
	position_map["taylor"] = taylor_end_position
	for c in get_children():
		if c is AnimationPlayer:
			animation_player = c
			c.connect("animation_finished", done)
			continue
		if c is Area2D:
			trigger = c
			c.connect("body_entered", triggered)

func triggered(player: Node2D):
	if already:
		return
	if not player.has_method("is_player") or not player.is_player():
		return
	already = true
	map = player.get_parent()
	for f in player.party + [player]:
		party.push_back(f)
		map.remove_child(f)
	
	animation_player.play("base")

func done(id):
	for f in party:
		f.position = position_map[f.id]
		f.clear_follower_data()
		map.add_child(f)
