extends Line2D

@export var elk: CharacterBody2D

@export var turn_threshold = 10

@export var hitbox_threshold = 30

@export var a_destination_node = "../.."
@export var b_destination_node = ".."
@export var world = "../.."
@export var a_destination_collision_layer = glob.UNIVERSAL_COLLISION_LAYER
@export var b_destination_collision_layer = glob.SUB_ROOM_COLLISION_LAYER

var reverse = false

var elk_arrived = false

@export var speed = 300
var warmup = false

var ix = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	$A.set_collision_layer_value(a_destination_collision_layer, true)
	$A.set_collision_mask_value(a_destination_collision_layer, true)
	$B.set_collision_layer_value(b_destination_collision_layer, true)
	$B.set_collision_mask_value(b_destination_collision_layer, true)
	
	$A.position = points[0]
	$B.position = points[-1]
	
	self_modulate = glob.TRANSPARENT
	refresh_reverse()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if not glob.g.player.mode == status.MODE.ELK:
		$Button.visible = false
		return
	$Button.visible = true

	if warmup or not elk:
		return
	
	if elk.global_position.distance_to(position_by_ix(ix)) < turn_threshold:
		iterate()
	
	if not position_by_ix(ix):
		elk.velocity = Vector2(0, 0)
		var p: Node2D = get_node(b_destination_node)
		if reverse:
			p = get_node(a_destination_node)
			elk.land_sub_room(a_destination_collision_layer)
		else:
			elk.land_sub_room(b_destination_collision_layer)
		var global_pos = elk.get_global_transform().get_origin()
		if p != elk.get_parent():
			elk.get_parent().remove_child(elk)
			elk.position = global_pos - p.get_global_transform().get_origin()
			p.add_mob(elk)
		elk = null
		return
	
	var d = elk.global_position.direction_to(position_by_ix(ix)).normalized()
	elk.velocity = d * speed


func position_by_ix(some_ix):
	if some_ix < 0 or some_ix >= points.size():
		return null
	return global_position + points[some_ix]

func approach(some_elk):
	ix = 0
	if reverse:
		ix = points.size() - 1
	if elk_arrived:
		jump(glob.g.player.ELK)
		return
	some_elk.seek(position_by_ix(ix))

func jump(some_elk):
	if glob.g.player.mode != status.MODE.ELK:
		return
	if not position_by_ix(ix):
		return
	elk = some_elk
	elk.fly()
	elk.position = position_by_ix(ix) - elk.get_parent().global_position
	warmup = true
	await get_tree().create_timer(elk.jump_warmup).timeout
	elk.z_index = 1
	warmup = false

func iterate():
	if reverse:
		ix -= 1
		return
	ix += 1

func refresh_reverse():
	var some_elk: CharacterBody2D = glob.g.player.ELK
	
	if some_elk.get_collision_layer_value(b_destination_collision_layer):
		reverse = true
		return
	reverse = false


func _on_button_pressed():
	refresh_reverse()
	if not glob.g.player.mode == status.MODE.ELK:
		return
	approach(glob.g.player.ELK)


func _on_button_mouse_entered():
	status.ui_hovered = true


func _on_button_mouse_exited():
	status.ui_hovered = false


func body_entered_end(body):
	var some_elk = glob.g.player.ELK
	if body != some_elk:
		return
	elk_arrived = true
	if glob.g.player.ELK.cur_seeking:
		glob.g.player.ELK.cur_seeking = null
		jump(glob.g.player.ELK)

func body_exited_end(body):
	var some_elk = glob.g.player.ELK
	if body == some_elk:
		elk_arrived = false

func _on_a_body_entered(body):
	body_entered_end(body)

func _on_b_body_entered(body):
	body_entered_end(body)


func _on_a_body_exited(body):
	body_exited_end(body)


func _on_b_body_exited(body):
	body_exited_end(body)
