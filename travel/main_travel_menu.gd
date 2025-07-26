extends Control

@export var event_manager: TravelEvents


# Called when the node enters the scene tree for the first time.
func _ready():
	#stop()
	#start()
	pass


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
	event_manager.start_thinking()
	stop()


func _on_talk_mouse_entered():
	$Pane/Talk/Wrap.modulate = "#000000"


func _on_talk_mouse_exited():
	$Pane/Talk/Wrap.modulate = "#ffffff"
	


func _on_talk_pressed():
	event_manager.start_talking()
	stop()
