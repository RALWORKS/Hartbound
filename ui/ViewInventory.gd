extends Node

@export var top = 100
@export var left = 100
@export var width = 500
@export var spacing = 130

var InventoryButton = preload("res://ui/inventory_button.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	refresh_inventory()


func refresh_inventory():	
	for child in $"../Body/Data".get_children():
		child.queue_free()
	
	var x = left
	var y = top
	inv.init_inventory_if_needed()
	
	var data = state.get_state(["inventory"])
	
	if data.size() == 0:
		$"../Body/EmptyIndicator".visible = true
	else:
		$"../Body/EmptyIndicator".visible = false
	
	for item_id in data:
		var item = $"../InventoryMap".data[item_id]
		var btn = InventoryButton.instantiate()
		btn.set_item(item)
		btn.position = Vector2(x, y)
		$"../Body/Data".add_child(btn)
		x += spacing
		if x > width:
			x = left
			y += spacing
		
