extends Node

var RadioChild = preload("res://ui/radio-child.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if $"../RadioParent".value != null and $"../../Proceed".disabled:
		$"../../Proceed".disabled = false
		$"../../Proceed".text = "Continue"

func on_start():
	var NAME = $"../../../3/CharacterNamer".selected_name["name"]
	var title_text = $"../../Title".get_parsed_text().format({"n": NAME})
	var loading_text = $"../Loading/RichTextLabel".get_parsed_text().format({"n": NAME})
	$"../../Title".clear()
	$"../../Title".append_text(title_text)
	$"../Loading/RichTextLabel".clear()
	$"../Loading/RichTextLabel".append_text(loading_text)
	await get_tree().create_timer(0.3).timeout
	$"../../Nicknamer".load_names(NAME)


func on_names_loaded():
	make_name_buttons($"../../Nicknamer".NAMES)
	$"../Loading".free()

func make_name_buttons(names):
	var x = 50
	var y = 50
	var yinc = 55
	var xinc = 350
	var child_size = Vector2(300, 40)
	for n in names:
		var btn = RadioChild.instantiate()
		btn.value = n
		btn.text = n
		btn.position = Vector2(x, y)
		btn.size = child_size
		$"../RadioParent".add_child(btn)
		y += yinc
		if y > 300:
			y = 50
			x += xinc
		btn.connect("pressed", func(): _on_btn_clicked(btn))


func _on_nicknamer_names_loaded():
	on_names_loaded()

func _on_btn_clicked(child):
	var NAME = $"../../../Saver".NAME
	NAME["human_short"] = child.value
	$"../../../Saver".on_name_edited(NAME)
	print(NAME)
