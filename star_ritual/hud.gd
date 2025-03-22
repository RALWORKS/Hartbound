extends CanvasLayer


var MAX_HEALTH: int

@export var WARNING_COLOR: Color = "#ffbb00ff"
@export var DANGER_COLOR: Color = "#ff3000ff"

# Called when the node enters the scene tree for the first time.
func _ready():
	MAX_HEALTH = $HealthMax.size.x


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func set_time_fraction(f):
	$Health.size.x = f * MAX_HEALTH
	if f > 0.75:
		return
	if f > 0.5:
		$Health.modulate = WARNING_COLOR
		return
	$Health.modulate = DANGER_COLOR
	if f > 0.35:
		return
	$SubViewport/Profile.scowl()
	if f < 0.25:
		$AnimationPlayer.play("crisis", -1, 1.5)
