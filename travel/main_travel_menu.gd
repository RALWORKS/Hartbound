extends Control

@export var talker: Node2D
@export var thinker: Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	stop()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	

func start():
	visible = true
	process_mode = Node.PROCESS_MODE_INHERIT

func stop():
	visible = false
	process_mode = Node.PROCESS_MODE_DISABLED

func _on_ponder_mouse_entered():
	$Pane/Ponder/Wrap.modulate = "#000000"



func _on_ponder_mouse_exited():
	$Pane/Ponder/Wrap.modulate = "#ffffff"


func _on_ponder_pressed():
	thinker.play()
	stop()


func _on_talk_mouse_entered():
	$Pane/Talk/Wrap.modulate = "#000000"


func _on_talk_mouse_exited():
	$Pane/Talk/Wrap.modulate = "#ffffff"
	


func _on_talk_pressed():
	talker.play()
	stop()
