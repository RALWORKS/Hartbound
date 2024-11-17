extends CharacterBody2D

var char: CharacterBody2D = null


var POSITIONS = {
	"down": Vector2(-40, -5),
	"down-stopped": Vector2(-40, -5),
	"up": Vector2(30, -5),
	"up-stopped": Vector2(30, -5),
	"left": Vector2(-20, -10),
	"left-stopped": Vector2(-20, -10),
	"right": Vector2(-20, 10),
	"right-stopped": Vector2(-20, 10),
	"down-right": Vector2(-50, -10),
	"down-right-stopped": Vector2(-40, -10),
	"down-left": Vector2(-30, -10),
	"down-left-stopped": Vector2(-30, -10),
	"up-right": Vector2(30, 0),
	"up-right-stopped": Vector2(30, 0),
	"up-left": Vector2(40, 10),
	"up-left-stopped": Vector2(40, 10),
}
var LAYERS = {
	"down": 0,
	"down-stopped": 0,
	"up": 1,
	"up-stopped": 1,
	"left": 0,
	"left-stopped": 0,
	"right": 1,
	"right-stopped": 1,
	"down-right": 0,
	"down-right-stopped": 0,
	"down-left": 0,
	"down-left-stopped": 0,
	"up-right": 1,
	"up-right-stopped": 1,
	"up-left": 1,
	"up-left-stopped": 1,
}

func set_player(p: CharacterBody2D):
	#p.position = Vector2(-position.x, -position.y)

	p.get_parent().remove_child(p)
	add_child(p)
	p.animation_proxy = self
	char = p
	char.collision_mask = 2
	char.collision_layer = 2
	$InteractBox.connect("body_entered", char.interact_hit)
	$InteractBox.connect("body_exited", char.interact_exited)
	$InteractBox.connect("area_entered", char.interact_hit)
	$InteractBox.connect("area_exited", char.interact_exited)
	$NPC.force_enter_range()


func sort_layers(anim):
	if LAYERS[anim] == 1:
		$NPC.move_to_front()
	else:
		char.move_to_front()

func position_characters(anim):
	var pos = POSITIONS[anim]
	$NPC.position = pos
	char.position = Vector2(0,0)

func play(anim):
	sort_layers(anim)
	position_characters(anim)
	$NPC.play(anim)
	
