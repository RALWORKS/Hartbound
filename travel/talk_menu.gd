extends Control

@export var event_manager: TravelEvents

var SmartButton = preload("res://cutscene/smart_button.tscn")

var PARTY = {
	"taylor": "<taylor>",
	"brona": "Brona",
	"jerry": "Jerry",
	"nate": "Nate"
}


# Called when the node enters the scene tree for the first time.
func _ready():
	stop()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func start():
	var party = $"/root/Game".get_followers_from_state()
	make_buttons(party)
	visible = true
	process_mode = Node.PROCESS_MODE_INHERIT

func stop():
	visible = false
	process_mode = Node.PROCESS_MODE_DISABLED

func make_buttons(party):
	var ix = 0
	for c in party:
		var b = SmartButton.instantiate()
		b.manual_click_action = true
		b.position = Vector2(20, ix * 100)
		b.size = Vector2(580, 70)
		b.text = PARTY[c]
		b.connect("pressed", func (): event_manager.hi(c))
		$Pane/Data.add_child(b)
		ix += 1
