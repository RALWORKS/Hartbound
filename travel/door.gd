extends Node2D

@export_file var dest_resource = ""
@export var dest_edge = "NorthDoor"
@export var disabled: bool = false

@export var follower_offset = Vector2(-30, 0)

var entered = false
var loading = true

var dest

# Called when the node enters the scene tree for the first time.
func _ready():
#	$Spawner.position.x *= scale_spawner_x_position
#	$Spawner.position.y *= scale_spawner_y_position
	_enable()
	dest = load(dest_resource).instantiate()

func _enable():
	await get_tree().create_timer(0.3).timeout
	loading = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func _on_hitbox_body_entered(body):
	if entered:
		return
	
	if loading:
		return
	
	if disabled:
		return

		
	if not body.has_method("is_player") or not body.is_player():
		return
		
	entered = true
	
	var map = get_node("/root/Game/Map")
	if dest_resource:
		map.traverse(dest, dest_edge)

func spawn(g):
	$Spawner.follower_offset = follower_offset
	$Spawner.spawn(g)


func _on_hitbox_body_exited(_body):
	entered = false
