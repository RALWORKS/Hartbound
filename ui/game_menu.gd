extends Node2D

var game = null

var SmartLabel = preload("res://abstract/cutscene/smart_label.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	game = $"/root".get_node_or_null("Game")
	glob.g.connect("player_mode_changed", player_mode_changed)
	#player_mode_changed(glob.g.player.mode)
	#refresh_data($CharacterRecord)

func player_mode_changed(new_mode):
	if new_mode == status.MODE.ELF:
		$"../HartboundIndicator".modulate = glob.WHITE
		$"../HartIndicator".modulate = glob.TRANSPARENT
		$"../PartySlot/RideButton".off()
	elif new_mode == status.MODE.ELK:
		$"../HartboundIndicator".modulate = glob.TRANSPARENT
		$"../HartIndicator".modulate = glob.WHITE
		$"../PartySlot/RideButton".off()
	else:
		$"../HartboundIndicator".modulate = glob.TRANSPARENT
		$"../HartIndicator".modulate = glob.TRANSPARENT
		$"../PartySlot/RideButton".on()

func refresh_data(character_record=null):
	if not game:
		return
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func _on_hartbound_btn_pressed():
	glob.g.player.mode = status.MODE.ELF


func _on_elk_btn_pressed():
	glob.g.player.mode = status.MODE.ELK


func _on_ride_button_pressed():
	glob.g.player.mode = status.MODE.RIDER


func _on_hold_position_button_pressed():
	$"../PartySlot/HoldPositionButton".toggle()
	glob.g.player.hold_position = $"../PartySlot/HoldPositionButton".is_on


func _on_mouse_block_mouse_entered():
	status.ui_hovered = true
	print("treeeeeeuueueu")

func _on_mouse_block_mouse_exited():
	status.ui_hovered = false
	print("fallllale")
