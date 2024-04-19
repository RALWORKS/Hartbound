extends Node2D

var reflections: Array = []

var ReflectionBtn = preload("res://ui/reflection_resolver.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	$"../../ReflectionMap".refresh()
	refresh_reflections()
	refresh_display()
	
	if reflections.size() == 0:
		show_codex()

func refresh_reflections():
	var ids = $"/root/Game".list_reflections()
	
	reflections = []
	
	for i in ids:
		reflections.push_back($"../../ReflectionMap".get_data(i))


func refresh_display():
	for c in $ScrollContainer/Data.get_children():
		c.free()
		
	if reflections.size() == 0:
		$Empty.visible = true
	else:
		$Empty.visible = false
	
	for reflection in reflections:
		_add_reflection(reflection)

func reflect(reflection):
	reflection.play()
	$"../..".call_deferred("close")


func _add_reflection(reflection):
	var btn = ReflectionBtn.instantiate()
	btn.title = $"../../StateTagReplacer".replace(reflection.title)
	btn.description = $"../../StateTagReplacer".replace(reflection.description)
	btn.refresh()
	btn.connect("pressed", func(): reflect(reflection))
	$ScrollContainer/Data.add_child(btn)


func _on_to_codex_pressed():
	show_codex()

func show_codex():
	$".".visible = false
	$"../Codex".visible = true
