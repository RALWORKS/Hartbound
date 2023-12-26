extends Node2D

var UnlockedSprite = preload("res://chapters/demo/1/rift.-with-bridge.tscn")
var state_var = "c_unlocked"

@export var is_unlocked = false
var game = null

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

func refresh_unlocked():
	if get_unlocked_state or is_unlocked:
		$Rift.call_deferred("free")
		var rift = UnlockedSprite.instantiate()
		add_child(rift)

# Called when the node enters the scene tree for the first time.
func _ready():
	refresh_unlocked()

func unlock():
	set_unlocked_state(true)
	refresh_unlocked()
