extends Node


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func init_inventory_if_needed():
	var inv = state.get_state(["inventory"])
	if inv != null:
		return
	state.set_state(["inventory"], [])
	
func remove_item(item):
	init_inventory_if_needed()
	var new_inventory = state.get_state(["inventory"]).filter(func(i): return i != item.id)
	state.set_state(["inventory"], new_inventory)

func add_item(item):
	init_inventory_if_needed()
	state.set_state_push_to_key(["inventory"], item.id)

func contains(item_id):
	init_inventory_if_needed()
	return item_id in state.get_state(["inventory"])
