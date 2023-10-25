extends Node2D

@onready var concepts: Node = get_tree().get_root().get_node("Game/ConceptMap")

signal concept_chosen(concept)

# Called when the node enters the scene tree for the first time.
func _ready():
	var x = 100
	
	for category in concepts.get_children():
		var title = RichTextLabel.new()
		title.add_theme_color_override("default_color", "#ffffff")
		title.append_text(category.category)
		title.size = Vector2(400, 50)
		title.position = Vector2(x, 50)
		$".".add_child(title)
		
		var y = 120
		
		for concept in category.get_children():
			var btn = Button.new()
			btn.size = Vector2(350, 50)
			btn.text = concept.title
			btn.position = Vector2(x, y)
			btn.pressed.connect(func(): concept_chosen.emit(concept))
			$".".add_child(btn)
			y += 70
		x += 400

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
