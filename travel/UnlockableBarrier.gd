extends Node2D

@export var UnlockedSprite: Resource
@export var LockedSprite: Resource
@export var state_var = ""

@export var is_unlocked = false
var game = null
@export var sprite: Node = null

func _get_game():
	if game == null:
		game = $"/root/game"
	return game

func get_unlocked_state():
	var g = _get_game()
	var st = g.get_state(["micro_progress", state_var])
	if st == null:
		return false
	return st

func set_unlocked_state(value):
	var g = _get_game()
	g.set_state(["micro_progress", state_var], value)

func set_sprite(Klass):
	if sprite != null:
		sprite.free()
	if Klass == null:
		return
	sprite = Klass.instantiate()
	add_child(sprite)

func refresh_unlocked():
	if get_unlocked_state or is_unlocked:
		set_sprite(UnlockedSprite)
		return
	set_sprite(LockedSprite)

# Called when the node enters the scene tree for the first time.
func _ready():
	assert(state_var.length() > 0)
	refresh_unlocked()

func unlock():
	set_unlocked_state(true)
	refresh_unlocked()
