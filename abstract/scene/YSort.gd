extends Node2D

var SORT_FUNCTION = "check_should_be_behind"

var mobs = []


func add_mob(mob: Node2D):
	mobs.push_back(mob)
	add_child(mob)

func compare_y(a, b):
	return a.position.y < b.position.y

# Called when the node enters the scene tree for the first time.
func _ready():
	initial_ysort()

func initial_ysort():
	var c = get_children()
	c.sort_custom(compare_y)
	var i = 0
	while i < c.size():
		move_child(c[i], i)
		i = i + 1
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	for mob in mobs:
		ysort(mob)
	
func ysort(mob):
	var targets = get_children().duplicate()
	for c in targets:
		sort_item(c, mob)


func check_should_be_behind(item: Node2D, mob: Node2D):
	return item.position.y <= mob.position.y


func sort_item(item: Node2D, mob: Node2D):
	if item == mob:
		return
	var targ = self
	if item.has_method(SORT_FUNCTION):
		targ = item

	var should_be_behind = glob.f_of(targ, SORT_FUNCTION, [item, mob])
	
	var is_behind = item.get_index() < mob.get_index()
	
	
	if should_be_behind == is_behind:
		return

	if should_be_behind:
		move_child(mob, item.get_index())
		return

	move_child(mob, item.get_index() + 1)
	
	
