extends Cutscene


func _ready():
	super._ready()
	
	if input_data is Biome:
		teleport_to = input_data.get_camp()
	if input_data is MapEncounter:
		teleport_to = input_data.destination_scene.instantiate()
		closing_notification = input_data.arrival_notification
	input_data.free()
