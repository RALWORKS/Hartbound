extends Node2D

@export var spawn_at = "s"
@export var SPAWN_POINTS = {
	"s": $Spawner,
}

# Called when the node enters the scene tree for the first time.
func _ready():
	SPAWN_POINTS[spawn_at].spawn()
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
