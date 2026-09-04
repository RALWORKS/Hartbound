extends Line2D

@export var elk: CharacterBody2D

@export var turn_threshold = 10

@export var hitbox_threshold = 30

var reverse = false

@export var speed = 300
var warmup = false

var ix = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	self_modulate = glob.TRANSPARENT
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if not glob.g.player.mode == status.MODE.ELK:
		$Button.visible = false
		return
	$Button.visible = true
	
	if (
		position_by_ix(ix)
		and glob.g.player.ELK.cur_seeking == position_by_ix(ix)
		and glob.g.player.ELK.position.distance_to(position_by_ix(ix)) < hitbox_threshold
	):
		glob.g.player.ELK.cur_seeking = null
		jump(glob.g.player.ELK)

	if warmup or not elk:
		return
	
	if elk.position.distance_to(position_by_ix(ix)) < turn_threshold:
		iterate()
	
	if not position_by_ix(ix):
		elk.velocity = Vector2(0, 0)
		if reverse:
			elk.land_main_room()
		else:
			elk.land_sub_room()
		elk = null
		reverse = not reverse
		return
	
	var d = elk.position.direction_to(position_by_ix(ix)).normalized()
	elk.velocity = d * speed


func position_by_ix(some_ix):
	if some_ix < 0 or some_ix >= points.size():
		return null
	return position + points[some_ix]

func approach(some_elk):
	ix = 0
	if reverse:
		ix = points.size() - 1
	print("app ", ix)
	some_elk.seek(position_by_ix(ix))

func jump(some_elk):
	elk = some_elk
	elk.fly()
	elk.position = position_by_ix(ix)
	warmup = true
	await get_tree().create_timer(elk.jump_warmup).timeout
	warmup = false

func iterate():
	if reverse:
		ix -= 1
		return
	ix += 1


func _on_button_pressed():
	print("click")
	if not glob.g.player.mode == status.MODE.ELK:
		return
	approach(glob.g.player.ELK)


func _on_button_mouse_entered():
	status.ui_hovered = true


func _on_button_mouse_exited():
	status.ui_hovered = false
