extends Node

@export var layer = 2
@export var follow_viewport_enabled = true

var target: Node
var wrap: CanvasLayer
var real_parent: Node
var initial_visibility = true

# Called when the node enters the scene tree for the first time.
func _ready():
	raise_parent()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	consolidate_visibility()

func consolidate_visibility():
	if wrap == null:
		return
	
	var v = true
	var t = wrap.get_parent()
	
	while t != null:
		if not "visible" in t:
			break
		if not t.visible:
			v = false
			break
		t = t.get_parent()
	
	wrap.visible = v

func raise_parent():
	target = get_parent()
	real_parent = target.get_parent()
	
	if "_real_parent" in target:
		target._real_parent = real_parent
	
	if "raise_to_ui_layer" in target and not target.raise_to_ui_layer:
		return
	
	wrap = CanvasLayer.new()
	wrap.layer = layer
	wrap.follow_viewport_enabled = follow_viewport_enabled
	
	real_parent.call_deferred("add_child", wrap)
	real_parent.call_deferred("remove_child", target)
	wrap.call_deferred("add_child", target)
