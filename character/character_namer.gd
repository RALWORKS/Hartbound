extends Node2D

var CheckBtn = preload("res://ui/radio-child.tscn")

const DIMINUATIVE = "[diminuative]"

@export var send_data_to: Node
@export var change_handler: Node2D

var char_name = null

var selected_name = null

var export_data = {
	"short": null,
	"elf_short": null,
	"short_def": null,
	"full": null,
	"full_def": null,
}

func select_name(nickname, btn):
	selected_name = {
		"name": nickname[0],
		"full_name": char_name[0]
	}
	export_data = {
		"short": nickname[0],
		"elf_short": nickname[0],
		"short_def": nickname[1],
		"full": char_name[0],
		"full_def": char_name[1],
	}
	if change_handler:
		change_handler.name_updated()
	if send_data_to and send_data_to.has_method("on_name_edited"):
		send_data_to.on_name_edited(export_data)
	$ShortForms.reset()
	btn.set_pressed_no_signal(true)

func _make_name_buttons(nicknames):
	var container = $ShortForms
	container.reset()
	for child in container.get_children():
		child.free()
	var y = 0
	var x = 0
	for nick in nicknames:
		var btn = CheckBtn.instantiate()
		btn.position = Vector2(x, y)
		btn.size = Vector2(470, 70)
		btn.text = nick[0] + "\n(from " + nick[1] + ")"
		btn.connect("pressed", func (): select_name(nick, btn))
		container.add_child(btn)
		
		if x >= 490:
			x = 0
			y += 90
		else:
			x += 490

func reroll_names():
	selected_name = null
	char_name = generate_names()[0]
	$FullName.set_text("" + char_name[0] + "")
	$Definition.set_text("\"" + char_name[1] + "\"")
	_make_name_buttons(char_name[2])

# Called when the node enters the scene tree for the first time.
func _ready():
	reroll_names()
	

func choose(options):
	return options[randi() % options.size()]

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func _push_data_item (item, klass, glossary):
	var entry = {
		"mora": item["mora"],
		"name": item["name"] if "name" in item else null,
		"gloss": item["gloss"]
	}
	glossary[klass].push_back(entry)
	glossary.glossary[item["mora"]] = entry


func _parse_name_data():
	var glossary = {
		"noun": [],
		"adjective": [],
		"preposition": [],
		"intransitive": [],
		"transitive": [],
		"animate": [],
		"deity": [],
		"blessing": [],
		"adnoun": [],
		"glossary": {}
	}
	var structures = NAME_DATA["phrases"]

	for base in NAME_DATA["moras"]:
		_push_data_item(base, base["class"][0], glossary)
		if base["class"].size() == 1:
			continue

		for klass in base["class"].slice(1):
			_push_data_item(base[klass], klass, glossary)

	return [structures, glossary]

func _generate_name(structures, glossary):
	var template = choose(structures)
	var structure = template.split(" ")
	var interpreted = []
	var interpolated = []
	for word in structure:
		if word == ";":
			interpreted.push_back({"mora": "", "gloss": ";"})
			continue

		if word[0] != "=":
			interpreted.push_back(glossary["glossary"][word])
			continue

		var core = word.substr(1, word.length() -1)
		var n = int(core)
		if core.is_valid_int() and interpolated.size() > n:
			interpreted.push_back(interpolated[n])
			continue

		var chosen = choose(glossary[core])
		while (
			chosen["mora"]
			== (
					interpolated[interpolated.size() - 1]["mora"] 
					if interpolated.size() > 0
					else null
				)
			):
			chosen = choose(glossary[core])

		interpolated.push_back(chosen)
		interpreted.push_back(chosen)
	return [
		" ".join(interpreted.map(
	  		func (w): return w["mora"].substr(0, 1).to_upper() + w["mora"].substr(
				1, w["mora"].length()
			).replace(" '", "'")
		)),
		" ".join(interpreted.map(func (w): return w["gloss"])),
		make_nicknames(interpreted.map(func (w): return w["mora"]).filter(func (t): return t), glossary),
  	]

func generate_names():
	var data = _parse_name_data()

	var structures = data[0]
	var glossary = data[1]
	return range(1).map(func (_x): return _generate_name(structures, glossary))


func _get_definition(c, glossary, is_first):
	if c not in glossary["glossary"]:
		return DIMINUATIVE
	var gloss = glossary["glossary"][c]
	return gloss["name"] if gloss["name"] and is_first else gloss["gloss"]

func _format_definitions(components, glossary):
	var defs = components.slice(1).map(func (c): return _get_definition(c, glossary, false))
	defs.push_front(_get_definition(components[0], glossary, true))
	var is_dim = false
	if DIMINUATIVE in defs:
		defs = defs.filter(func (c): return c != DIMINUATIVE)
		is_dim = true
	defs[0] = "\"" + defs[0]
	defs[-1] = defs[-1] + "\""
	if is_dim:
		defs.push_front("diminuative of")
	return " ".join(defs)

func make_nicknames(tokens, glossary):
	var _names = []
	var pairs = []
	var data = []
	var nSkipped = 0
	var i = 0
	while i < 6:
		var sub_data = NICKNAME_PATTERNS[randi() % NICKNAME_PATTERNS.size()].call(tokens)
		var _name = sub_data[0]
		var components = sub_data[1]
		var distinctness = 0
		if pairs.size() == 0:
			distinctness = 2

		for tok in components:
			var isEnding = false
			if NAME_ENDINGS.find(tok) > -1:
				isEnding = true

			if not (pairs.size() > 0 && pairs[pairs.size() - 1].find(tok) > -1):
				distinctness += 1
				if not isEnding:
					distinctness += 1

			if (!isEnding &&
				!(pairs.size() > 1 && pairs[pairs.size() - 2].find(tok) > -1)
			):
				distinctness += 1

		for tok in (pairs[pairs.size() -1] if pairs.size() > 0 else []):
			var isEnding = false
			if NAME_ENDINGS.find(tok) > -1:
				isEnding = true
			if isEnding:
				continue
			if components.find(tok) == -1:
				distinctness += 1

		if nSkipped < 40:
			if _names.find(_name) > -1 || distinctness < 5:
				#print(_name, " probably too similar!")
				nSkipped += 1
				continue

			if _name.length() > 15 || (_name.length() > 11 && randf() > 0.3):
				nSkipped += 1
				#print(_name, " probably too long!")
				continue
		else:
			print("Name quality-check circuit-breaker engaged")

		var def = _format_definitions(components, glossary)
		data.push_back([_name, def])
		_names.push_back(_name)
		i += 1

	return data

const NAME_ENDINGS = ["a", "i", "e", "os", "as", "tya", "anna", "us", "is"]

func _mutate_word_for_next(word: String, next: String):
	var terminal = word[word.length() -1]
	var initial = next[0]
	if terminal not in JOIN_MUTATIONS or initial not in JOIN_MUTATIONS[terminal]:
		return word

	var replacementTerminal = JOIN_MUTATIONS[terminal][initial]
	if typeof(replacementTerminal) != TYPE_STRING:
		return word
	var mutated = word.substr(0, word.length() -1) + replacementTerminal
	return mutated
	

func _joiner(orig: Array):
	var tokens = orig.duplicate()
	var prev = 0

	for word in orig.slice(1):
		var lastWord = tokens[prev]
		tokens[prev] = _mutate_word_for_next(lastWord, word)

	var _name = "".join(tokens).to_lower()

	for key in MUTATE_PAIRS:
		_name = _name.replace(key, MUTATE_PAIRS[key])

	return [
	_name.substr(0, 1).to_upper() + _name.substr(1, _name.length() - 1),
	orig
  ]

func _join2(n):
	if n.size() < 3:
		return _joiner(n)

	var ix = randi() % n.size()
	if ix > n.size() - 3:
		ix = n.size() - 3

	var words = n.slice(ix, ix + 2)
	return _joiner(words)

func _join2_with_ending(n):
	var data = _join2(n)
	var ender = NAME_ENDINGS[randi() % NAME_ENDINGS.size()]
	var merged = _joiner([data[0], ender])
	data[1].push_back(ender)
	return [merged[0], data[1]]

func _join1_with_ending(n):
	var word = n[randi() % n.size()]
	return _joiner([word, NAME_ENDINGS[randi() % NAME_ENDINGS.size()]])

func _join3_and_cull(n):
	if n.size() < 3:
		return _joiner(n)

	var ix = randi() % n.size()
	if ix > n.size() - 3:
		ix = n.size() - 3

	var words = n.slice(ix, ix + 3)
	var mid = _joiner(words)
	
	for key in AGGRO_MUTATE_PAIRS:
		mid[0] = mid[0].replace(key, AGGRO_MUTATE_PAIRS[key])
	
	for key in MUTATE_PAIRS:
		mid[0] = mid[0].replace(key, MUTATE_PAIRS[key])
	
	return mid

func _join2_and_cull(n):
	if n.size() < 3:
		return _joiner(n)

	var ix = randi() % n.size()
	if ix > n.size() - 3:
		ix = n.size() - 3

	var words = n.slice(ix, ix + 2)
	var mid = _joiner(words)
	
	for key in AGGRO_MUTATE_PAIRS:
		mid[0] = mid[0].replace(key, AGGRO_MUTATE_PAIRS[key])
	
	for key in MUTATE_PAIRS:
		mid[0] = mid[0].replace(key, MUTATE_PAIRS[key])
	
	return mid

var NICKNAME_PATTERNS = [
	_join2,
	_join2_and_cull,
#	_join2_with_ending,
	_join1_with_ending,
	_join3_and_cull,
#	_join3_and_cull,
]

const JOIN_MUTATIONS = {
  "t": {
	"d": "'"
  },
  "n": {
	"r": "",
  },
}

const AGGRO_MUTATE_PAIRS = {
	"ayas": "si",
	"luyen": "lun",
	"shos": "s",
	"iy": "m",

	"eya": "e",
	"iya": "i",
	"aya": "a",
	"oya": "o",
	"uya": "e",
	"éya": "é",
	"íya": "í",
	"áya": "á",
	"óya": "ó",
	"úya": "ú",
	"era": "er",
	"ira": "ir",
	"ara": "ar",
	"ora": "or",
	"ura": "er",
	"éra": "ér",
	"ára": "ár",
	"íra": "ír",
	"óra": "ór",
	"úra": "úr",
	"esha": "she",
	"asha": "sha",
	"isha": "shi",
	"osha": "sho",
	"usha": "shu",
	"ésha": "shé",
	"ísha": "shí",
	"ásha": "shá",
	"ósha": "shó",
	"úsha": "shú",
	"ona": "no",
	"ina": "in",
	"ana": "an",
	"ena": "en",
	"una": "un",
	"éna": "én",
	"ána": "án",
	"ína": "ín",
	"óna": "ón",
	"úna": "ún",
	
	"eye": "e",
	"iye": "i",
	"aye": "a",
	"oye": "o",
	"uye": "e",
	"éye": "é",
	"íye": "í",
	"áye": "á",
	"óye": "ó",
	"úye": "ú",
	"ere": "er",
	"ire": "ir",
	"are": "ar",
	"ore": "or",
	"ure": "er",
	"ére": "ér",
	"áre": "ár",
	"íre": "ír",
	"óre": "ór",
	"úre": "úr",
	"eshe": "she",
	"ashe": "sha",
	"ishe": "shi",
	"oshe": "sho",
	"ushe": "shu",
	"éshe": "shé",
	"íshe": "shí",
	"áshe": "shá",
	"óshe": "shó",
	"úshe": "shú",
	"one": "no",
	"ine": "in",
	"ane": "an",
	"ene": "en",
	"une": "un",
	"éne": "én",
	"áne": "án",
	"íne": "ín",
	"óne": "ón",
	"úne": "ún",
	"shosh": "sh",
	"sush": "sh",
	"enén": "én",
	"shm": "m",
	"nen": "n",
#	"nan": "n",
	"nun": "n",
	"nin": "n",
	"non": "n",
	"rer": "r",
	"rar": "r",
	"rur": "r",
	"rir": "r",
	"ror": "r",
	"yny": "y",
	"aoe": "a",
	"ioe": "ye",
	"eyn": "e",
}

const MUTATE_PAIRS = {
	"rdr": "r",
	"drm": "dm",
	"lr": "r",
	"rl": "l",
	"yr": "yy",
	"dsh": "sh",
	"nnn": "nn",
	"mmm": "mm",
	"rsh": "ras",
	"ntm": "d",
	"sf": "f",
	"tg": "g",
	"nm": "mm",
	"shsh": "sh",
	"ai": "ae",
	"aa": "á",
	"oo": "ó",
	"uu": "ú",
	"ee": "é",
	"dt": "dd",
	"ii": "í",
	"ll": "'l",
	"hc": "sh",
	"eynus": "eyni",
	"eynis": "eyna",
	"eynas": "eyne",
	"eynos": "eynú",
	"ie": "ye",
	"ia": "ya",
	"ei": "ey",
	"ssh": "sh",
	"aá": "á",
	"áa": "á",
	"áá": "á",
	"oó": "ó",
	"óo": "ó",
	"óó": "ó",
	"uú": "ú",
	"úu": "ú",
	"úú": "ú",
	"ií": "í",
	"íi": "í",
	"íí": "í",
	"ée": "é",
	"eé": "é",
	"éé": "é",
}

var NAME_DATA = {
  "phrases": [
	"=adjective =noun ; =0 =noun",
	"=adjective =noun ; =adjective =1",
	"ul =adjective =noun il =noun",
	"=noun eon il =adjective =noun",
	"=noun ; =noun ; =noun ; =noun",
	"=adjective ; =adjective ; =adjective ; =adjective",
	"=adjective =noun ; =adjective =noun",
	"leín =adjective =adjective =noun",
	"laét =adjective =noun ul =noun",
	"gan =adjective =noun dan",
	"=noun leín =adjective =noun",
	"=noun laét =adjective =noun",
	"=noun eyn =noun ; =noun eyn =noun",
	"=noun il =noun ; =noun il =noun",
	"=animate il =adjective =noun eon",
	"=adjective sul ; =noun eyn sul",
	"rul =noun ; rul =adjective =0",
	"rul =noun il =adjective =noun",
	"=noun eyn =noun ; =0 eyn =noun",
	"=noun eyn =noun ; =noun eyn =0",
	#"=noun il =noun ; =1 il =0",
	"leín =noun ; =adjective =0",
	"laét =noun ; laét =noun",
	"leín =noun ; laét =noun",
	"=noun eon il =adjective sul",
	"=noun eon ; =noun eon",
	#"=noun rul =noun ; =1 rul =0",
	#"rul =noun ; rul =noun",
	"rul =deity ; rul =blessing",
	"=adjective =animate rul =deity",
	"=animate =intransitive ; =animate =intransitive",
	"=animate =transitive =adjective =noun",
	"=animate aluyensu =blessing ; =animate aluyen",
	"=animate aluyensa =deity ; aluyensu =blessing",
	"=adjective =animate aluyensu =blessing",
	"=adjective =animate aluyensa =deity",
	"=adjective =noun leín =noun",
	"=adjective =noun laét =noun",
	"=noun =transitive =animate il =noun",
	"=animate rul =noun =intransitive",
	"=animate =transitive =animate il =adjective =noun",
	"=animate =transitive =noun gan =deity",
	"=animate rul =deity =transitive =noun",
	"=adjective =animate rul =deity =intransitive",
	"=noun eyn =animate =intransitive",
	"=deity eyn =animate =intransitive",
	"=deity eyn =animate =transitive =noun",
	"=blessing eyn =adjective =animate =intransitive",
	"=animate eyn =blessing",
	"=deity eyn =blessing",
	"=noun =adnoun =transitive =noun",
	"=animate =transitive =noun =adnoun",
	"=adjective =noun =adnoun =intransitive",
	"=deity =transitive =adjective =noun",
	"=deity =transitive =deity",
	"=deity =transitive =blessing",
	"=deity =intransitive ; =deity =intransitive",
  ],
  "moras": [
	{
	  "mora": "ám",
	  "gloss": "soul",
	  "class": [
		"noun",
		"adjective",
		"animate",
		"deity",
	  ],
	  "adjective": {
		"mora": "ámu",
		"gloss": "soulful"
	  },
	  "animate": {
		"mora": "ámat",
		"gloss": "soul"
	  },
	  "deity": {
		"mora": "ámayas",
		"gloss": "Divine Soul"
	  },
	},
	{
	  "mora": "eyn",
	  "gloss": "'s own",
	  "name": "one's own",
	  "class": [
		"preposition"
	  ]
	},
	{
	  "mora": "il",
	  "gloss": "'s",
	  "name": "one's own",
	  "class": [
		"preposition"
	  ]
	},
	{
	  "mora": "oes",
	  "gloss": "strength",
	  "class": [
		"noun",
		"adjective"
	  ],
	  "adjective": {
		"mora": "oesi",
		"gloss": "strong"
	  }
	},
	{
	  "mora": "ul",
	  "gloss": "in the lineage of",
	  "class": [
		"preposition"
	  ]
	},
	{
	  "mora": "cen",
	  "gloss": "wisdom",
	  "class": [
		"noun",
		"adjective",
		"blessing",
	  ],
	  "adjective": {
		"mora": "cenu",
		"gloss": "wise"
	  },
	  "blessing": {
		"mora": "cen",
		"gloss": "wisdom"
	  }
	},
	{
	  "mora": "caen",
	  "gloss": "safety",
	  "class": [
		"noun",
		"blessing"
	  ],
	  "blessing": {
		"mora": "caen",
		"gloss": "safety"
	  },
	},
	{
	  "mora": "caet",
	  "gloss": "nectar",
	  "class": [
		"noun"
	  ]
	},
	{
	  "mora": "dan",
	  "gloss": "clan",
	  "class": [
		"noun"
	  ]
	},
	{
	  "mora": "cas",
	  "gloss": "peace",
	  "class": [
		"noun",
		"blessing"
	  ],
	  "blessing": {
		"mora": "cas",
		"gloss": "peace"
	  },
	},
	{
	  "mora": "dún",
	  "gloss": "music",
	  "class": [
		"noun"
	  ]
	},
	{
	  "mora": "dul",
	  "gloss": "grass",
	  "class": [
		"noun"
	  ]
	},
	{
	  "mora": "das",
	  "gloss": "simplicity",
	  "class": [
		"noun",
		"adjective"
	  ],
	  "adjective": {
		"mora": "daso",
		"gloss": "gentle"
	  }
	},
	{
	  "mora": "fen",
	  "gloss": "town",
	  "class": [
		"noun",
		"animate",
	  ],
	  "animate": {
		"mora": "fenad",
		"gloss": "town"
	  }
	},
	{
	  "mora": "fas",
	  "gloss": "-maker",
	  "class": [
		"adnoun",
		"noun",
		"animate",
		"deity"
	  ],
	  "noun": {
		"mora": "fás",
		"gloss": "artisan"
	  },
	  "animate": {
		"mora": "fasash",
		"gloss": "artisan"
	  },
	  "deity": {
		"mora": "fasayat",
		"gloss": "Great Maker"
	  },
	},
	{
	  "mora": "àcatas",
	  "gloss": "-eater",
	  "class": [
		"adnoun",
		"transitive"
	  ],
	  "transitive": {
		"mora": "àctensu",
		"gloss": "eats"
	  }
	},
	{
	  "mora": "maoltas",
	  "gloss": "-keeper",
	  "class": [
		"adnoun",
		"transitive"
	  ],
	  "transitive": {
		"mora": "maoltensu",
		"gloss": "keeps"
	  }
	},
	{
	  "mora": "faet",
	  "gloss": "gift",
	  "class": [
		"noun",
	  ],
	},
	{
	  "mora": "faon",
	  "gloss": "hero",
	  "class": [
		"noun",
		"adjective",
		"animate"
	  ],
	  "adjective": {
		"mora": "faone",
		"gloss": "formidable"
	  },
	  "animate": {
		"mora": "faonas",
		"gloss": "hero"
	  },
	},
	{
	  "mora": "gen",
	  "gloss": "earth",
	  "class": [
		"noun",
		"animate",
		"deity",
	  ],
	  "animate": {
		"mora": "genas",
		"gloss": "earth"
	  },
	  "deity": {
		"mora": "genayas",
		"gloss": "earth"
	  },
	},
	{
	  "mora": "gét",
	  "gloss": "elk",
	  "class": [
		"noun",
		"animate",
		"deity"
	  ],
	  "animate": {
		"mora": "gétash",
		"gloss": "elk"
	  },
	  "deity": {
		"mora": "gétayash",
		"gloss": "Elk God"
	  },
	},
	{
	  "mora": "gaed",
	  "gloss": "shaman",
	  "class": [
		"noun",
		"animate",
		"deity",
	  ],
	  "animate": {
		"mora": "gaedat",
		"gloss": "shaman"
	  },
	  "deity": {
		"mora": "gaedayat",
		"gloss": "First Shaman"
	  },
	},
	{
	  "mora": "gan",
	  "gloss": "for",
	  "class": [
		"preposition"
	  ]
	},
	{
	  "mora": "leín",
	  "gloss": "(is) with Her, who is",
	  "name": "with Her",
	  "class": [
		"preposition"
	  ]
	},
	{
	  "mora": "laét",
	  "gloss": "(is) with Him, who is",
	  "name": "with Him",
	  "class": [
		"preposition"
	  ]
	},
	{
	  "mora": "lús",
	  "gloss": "wolf",
	  "class": [
		"noun",
		"animate",
		"deity",
	  ],
	  "animate": {
		"mora": "lúsas",
		"gloss": "wolf"
	  },
	  "deity": {
		"mora": "lúsayas",
		"gloss": "Wolf God"
	  },
	},
	{
	  "mora": "lin",
	  "gloss": "little",
	  "class": [
		"adjective"
	  ]
	},
	{
	  "mora": "min",
	  "gloss": "flower",
	  "class": [
		"noun"
	  ]
	},
	{
	  "mora": "mat",
	  "gloss": "warrior",
	  "class": [
		"noun",
		"animate",
		"deity",
	  ],
	  "animate": {
		"mora": "matas",
		"gloss": "warrior"
	  },
	  "deity": {
		"mora": "matayas",
		"gloss": "God of Warriors"
	  },
	},
	{
	  "mora": "mal",
	  "gloss": "caution",
	  "class": [
		"noun",
		"adjective"
	  ],
	  "adjective": {
		"mora": "malu",
		"gloss": "cautious"
	  }
	},
	{
	  "mora": "mun",
	  "gloss": "poem",
	  "class": [
		"noun",
		"deity"
	  ],
	  "deity": {
		"mora": "munatas",
		"gloss": "Greate Muse"
	  },
	},
	{
	  "mora": "nén",
	  "gloss": "sun",
	  "class": [
		"noun",
		"adjective",
		"animate",
		"deity"
	  ],
	  "adjective": {
		"mora": "néna",
		"gloss": "bright"
	  },
	  "animate": {
		"mora": "nénad",
		"gloss": "sun"
	  },
	  "deity": {
		"mora": "nénayad",
		"gloss": "Sun God"
	  },
	},
	{
	  "mora": "yén",
	  "gloss": "moon",
	  "class": [
		"noun",
		"adjective",
		"animate",
		"deity"
	  ],
	  "adjective": {
		"mora": "yéna",
		"gloss": "shining"
	  },
	  "animate": {
		"mora": "yénad",
		"gloss": "moon"
	  },
	  "deity": {
		"mora": "yénayas",
		"gloss": "Moon God"
	  },
	},
	{
	  "mora": "nas",
	  "gloss": "water",
	  "class": [
		"noun",
		"deity",
	  ],
	  "deity": {
		"mora": "nasayas",
		"gloss": "Spirit of the Water"
	  },
	},
	{
	  "mora": "nan",
	  "gloss": "hope",
	  "class": [
		"noun",
		"blessing"
	  ],
	  "blessing": {
		"mora": "nan",
		"gloss": "hope"
	  },
	},
	{
	  "mora": "net",
	  "gloss": "yellow",
	  "class": [
		"adjective"
	  ]
	},
	{
	  "mora": "ras",
	  "gloss": "red",
	  "class": [
		"adjective"
	  ]
	},
	{
	  "mora": "run",
	  "gloss": "love",
	  "class": [
		"noun",
		"adjective"
	  ],
	  "adjective": {
		"mora": "runa",
		"gloss": "loving"
	  }
	},
	{
	  "mora": "rul",
	  "gloss": "devoted to",
	  "class": [
		"preposition"
	  ]
	},
	{
	  "mora": "saem",
	  "gloss": "tree",
	  "class": [
		"noun"
	  ]
	},
	{
	  "mora": "raem",
	  "gloss": "river",
	  "class": [
		"noun",
		"animate",
		"deity"
	  ],
	  "animate": {
		"mora": "raemas",
		"gloss": "river"
	  },
	  "deity": {
		"mora": "raemayas",
		"gloss": "Spirit of the River"
	  },
	},
	{
	  "mora": "sen",
	  "gloss": "fire",
	  "class": [
		"noun",
		"animate",
		"deity"
	  ],
	  "animate": {
		"mora": "senad",
		"gloss": "fire"
	  },
	  "deity": {
		"mora": "senayas",
		"gloss": "Fire God"
	  },
	},
	{
	  "mora": "soen",
	  "gloss": "fern",
	  "class": [
		"noun"
	  ]
	},
	{
	  "mora": "sun",
	  "gloss": "sky",
	  "class": [
		"noun",
		"animate",
	  ],
	  "animate": {
		"mora": "sunas",
		"gloss": "sky"
	  },
	},
	{
	  "mora": "set",
	  "gloss": "victory",
	  "class": [
		"noun",
		"adjective"
	  ],
	  "adjective": {
		"mora": "seto",
		"gloss": "victorious"
	  }
	},
	{
	  "mora": "sul",
	  "gloss": "path",
	  "class": [
		"noun"
	  ]
	},
	{
	  "mora": "ten",
	  "gloss": "symmetry",
	  "class": [
		"noun",
		"adjective"
	  ],
	  "adjective": {
		"mora": "teno",
		"gloss": "balanced"
	  }
	},
	{
	  "mora": "tul",
	  "gloss": "green",
	  "class": ["adjective"]
	},
	{
	  "mora": "tás",
	  "gloss": "abundance",
	  "class": [
		"noun",
		"adjective"
	  ],
	  "adjective": {
		"mora": "tási",
		"gloss": "abundant"
	  }
	},
	{
	  "mora": "tan",
	  "gloss": "courage",
	  "class": [
		"noun",
		"adjective"
	  ],
	  "adjective": {
		"mora": "tanu",
		"gloss": "courageous"
	  }
	},
	{
	  "mora": "yen",
	  "gloss": "grove",
	  "class": [
		"noun"
	  ]
	},
	{
	  "mora": "yet",
	  "gloss": "night",
	  "class": [
		"noun",
		"deity"
	  ],
	  "deity": {
		"mora": "yetayas",
		"gloss": "God of the Night"
	  },
	},
	{
	  "mora": "eon",
	  "gloss": "-walker",
	  "class": [
		"adnoun",
		"noun",
		"animate",
	  ],
	  "noun": {
		"mora": "eón",
		"gloss": "traveller",
	  },
	  "animate": {
		"mora": "eónad",
		"gloss": "traveller",
	  },
	},
	{
	  "mora": "yeal",
	  "gloss": "wheel",
	  "class": [
		"noun",
		"deity",
	  ],
	  "deity": {
		"mora": "yealayas",
		"gloss": "God of the Wheel"
	  },
	},
	{
	  "mora": "shiyen",
	  "gloss": "sings",
	  "class": [
		"intransitive",
		"transitive"
	  ],
	  "transitive": {
		"mora": "shiyensu",
		"gloss": "sings of"
	  }
	},
	{
	  "mora": "shiyensa",
	  "gloss": "sings to",
	  "class": [
		"transitive"
	  ],
	},
	{
	  "mora": "aluyen",
	  "gloss": "prays",
	  "class": [
		"intransitive",
		"transitive"
	  ],
	  "transitive": {
		"mora": "aluyensu",
		"gloss": "prays for"
	  },
	},
	{
	  "mora": "aluyensa",
	  "gloss": "prays to",
	  "class": [
		"transitive"
	  ],
	},
	{
	  "mora": "sécensa",
	  "gloss": "listens to",
	  "class": [
		"transitive"
	  ],
	},
	{
	  "mora": "séc",
	  "gloss": "sound",
	  "class": [
		"noun"
	  ],
	},
	{
	  "mora": "aluy",
	  "gloss": "prayer",
	  "class": [
		"noun"
	  ],
	},
	{
	  "mora": "shiy",
	  "gloss": "song",
	  "class": [
		"noun"
	  ],
	},
	{
	  "mora": "anaemen",
	  "gloss": "dances",
	  "class": [
		"intransitive", "noun", "adjective"
	  ],
	  "noun": {
		"mora": "anaem",
		"gloss": "dance",
	  },
	  "adjective": {
		"mora": "anaema",
		"gloss": "graceful"
	  }
	},
	{
	  "mora": "naen",
	  "gloss": "sleeps",
	  "class": [
		"intransitive"
	  ],
	},
	{
	  "mora": "acaoen",
	  "gloss": "bows",
	  "class": [
		"intransitive",
		"transitive"
	  ],
	  "transitive": {
		"mora": "acaoensu",
		"gloss": "bows to"
	  }
	},
	{
	  "mora": "cyól",
	  "gloss": "mouse",
	  "class": [
		"noun", "animate"
	  ],
	  "animate": {
		"mora": "cyólat",
		"gloss": "mouse",
	  }
	},
	{
	  "mora": "yóres",
	  "gloss": "snake",
	  "class": [
		"noun", "animate"
	  ],
	  "animate": {
		"mora": "yórest",
		"gloss": "snake",
	  }
	},
	{
	  "mora": "yurus",
	  "gloss": "frog",
	  "class": [
		"noun", "animate"
	  ],
	  "animate": {
		"mora": "yurust",
		"gloss": "frog",
	  }
	},
	{
	  "mora": "moér",
	  "gloss": "wild goose",
	  "class": [
		"noun", "animate"
	  ],
	  "animate": {
		"mora": "moérad",
		"gloss": "wild goose",
	  }
	},
	{
	  "mora": "saér",
	  "gloss": "crow",
	  "class": [
		"noun", "animate"
	  ],
	  "animate": {
		"mora": "saérad",
		"gloss": "crow",
	  }
	},
	{
	  "mora": "ashcaér",
	  "gloss": "hummingbird",
	  "class": [
		"noun", "animate"
	  ],
	  "animate": {
		"mora": "ashcaért",
		"gloss": "hummingbird",
	  }
	},
	{
	  "mora": "shésyen",
	  "gloss": "dies",
	  "class": [
		"intransitive",
		"transitive",
		"noun"
	  ],
	  "transitive": {
		"mora": "shésyénsu",
		"gloss": "kills"
	  },
	  "noun": {
		"mora": "shés",
		"gloss": "death",
	  },
	},
	{
	  "mora": "shosyen",
	  "gloss": "rests",
	  "class": [
		"intransitive",
		"transitive",
		"noun"
	  ],
	  "transitive": {
		"mora": "shoshyénsu",
		"gloss": "lays to rest"
	  },
	  "noun": {
		"mora": "shos",
		"gloss": "rest",
	  },
	},
	{
	  "mora": "soesyensu",
	  "gloss": "lies with",
	  "class": [
		"transitive",
	  ],
	},
	{
	  "mora": "rashmyen",
	  "gloss": "awakens",
	  "class": [
		"intransitive",
		"transitive",
		"noun"
	  ],
	  "transitive": {
		"mora": "rashmyensu",
		"gloss": "wakes"
	  },
	  "noun": {
		"mora": "rasham",
		"gloss": "awakening",
	  },
	},
	{
	  "mora": "corm",
	  "gloss": "mountain",
	  "class": [
		"noun",
		"adjective",
		"animate",
		"deity",
	  ],
	  "adjective": {
		"mora": "corme",
		"gloss": "mountainous"
	  },
	  "animate": {
		"mora": "cormat",
		"gloss": "mountain"
	  },
	  "deity": {
		"mora": "cormyas",
		"gloss": "Mountain God"
	  },
	},
	{
	  "mora": "cirim",
	  "gloss": "rock",
	  "class": [
		"noun",
	  ],
	},
	{
	  "mora": "táls",
	  "gloss": "holiness",
	  "class": [
		"noun",
		"adjective",
		"animate"
	  ],
	  "adjective": {
		"mora": "tálsa",
		"gloss": "holy"
	  },
	  "animate": {
		"mora": "tálsat",
		"gloss": "holiness"
	  },
	},
  ]
}


func _on_button_pressed():
	reroll_names()
