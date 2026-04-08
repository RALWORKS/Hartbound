extends Node2D
@export var your_name = ""
signal names_loaded

var name_index = "res://data/human-name-index.json"

"""
IMPORTANT:
	Godot had a bug at the time of writing where RegEx search and
	search_all were ignoring the first letter of the input, 
	consistently.
	I found results were improved by prepending a character (m)
	when doing each search, and if needed (in get_pattern), shifting
	the indeces of the matches when working with them
	
	These compensation strategies will need to be undone if a patch is
	released.
"""


var NAMES = []

var DEFAULT_NAMES = [
	"Abe",
	"Ace",
	"Al",
	"Ann",
	"Bob",
	"Bea",
	"Bill",
	"Bex",
	"Cat",
	"Cal",
	"Cass",
	"Dom",
	"Dee",
	"Dan",
	"El",
	"Evie",
	"Ed",
	"Fay",
	"Frank",
	"Fil",
	"Gem",
	"Garth",
	"Hal",
	"Hallie",
	"Herb",
	"Iggy",
	"Ima",
	"Ira",
	"Joe",
	"Jo",
	"Jon",
	"Jay",
	"Kat",
	"Kay",
	"Karl",
	"Kai",
	"Leo",
	"Lee",
	"Lara",
	"Lang",
	"Molly",
	"Matt",
	"Max",
	"Mac",
	"Mick",
	"Mike",
	"Mikey",
	"Mag",
	"Meg",
	"Nell",
	"Noah",
	"Nyx",
	"Nick",
	"Nikki",
	"Noel",
	"Nora",
	"Obi",
	"Orr",
	"Oona",
	"Oz",
	"Ozzie",
	"Pax",
	"Pat",
	"Paddy",
	"Patty",
	"Penelope",
	"Ren",
	"Red",
	"Rod",
	"Roo",
	"Ron",
	"Rana",
	"Rex",
	"Sev",
	"Seth",
	"Sonny",
	"Seb",
	"Sam",
	"Sammy",
	"Saul",
	"Sol",
	"Steph",
	"Steve",
	"Six",
	"Tom",
	"Tam",
	"Tal",
	"Tally",
	"Tim",
	"Tris",
	"Tina",
	"Uriah",
	"Una",
	"Uriel",
	"Vee",
	"Vi",
	"Vince",
	"Wan",
	"Wax",
	"Wanda",
	"Wing",
	"Yash",
	"Yen",
	"Yonah",
	"Zen",
	"Zara",
	"Zephyr",
	"Zeph",
]

# Called when the node enters the scene tree for the first time.
func _ready():
		#load_names()
		pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func load_names(use_name=your_name):
	your_name = use_name
	var nameset = main()
	if nameset!= null:
		NAMES = nameset.map(func(x): return x[0])
		for n in NAMES:
			$RichTextLabel.append_text(n + "\n")
		$RichTextLabel.visible = true
		Signal(self, "names_loaded").emit()


func nc(pattern):
	return "(%s)" % pattern

var VOWELS = ["a", "e", "i", "o", "u", "á", "à", "é", "è", "ì", "í", "ó", "ò", "ú", "ù"]
var VOWELS_PERMISSIVE = VOWELS + ["y", "w"]
var OPT_VOWEL = "[aeiouy]{0,3}"

var PATTERN_R = "w?r{1,2}"
var PATTERN_L = "l{1,2}"
var PATTERN_K = "(cqu?)|c{0,2}k|c{1,2}"
var PATTERN_C = "(sh)|(ch)|(s{0,2}[ck]?)|s{1,2}"
var PATTERN_M = "n{0,2}d?m{1,2}n{0,2}"
var PATTERN_B = "b{1,2}|p{1,2}|v"
var PATTERN_P = "b{1,2}|p{1,2}|f{1,2}|(pf)|(mf)"
var PATTERN_F = "f{1,2}|p{1,2}|v|(pf)|(mf)"
var PATTERN_N = "n{1,2}"#"m{0,2}n{1,2}m{0,2}"
var PATTERN_S = "(s{1,2}z?)|z{1,2}|c"
var PATTERN_D = "(t?d[dt]{0,2})|(th)|tt?"
var PATTERN_Y = "y|i|(ee)"
var PATTERN_E = "[eéèia]{1,3}[y]?"#"[eiaéè]{1,3}[y]?"
var PATTERN_A = "[aáà]+"#"[aeieéàáo]{1,3}[wy]?"
var PATTERN_I = "[iìieéè]{1,3}[y]?"
var PATTERN_U = "[uoùú]{1,3}[wh]?"
var PATTERN_O = "[oeóòô]{1,3}[wh]?"
var PATTERN_E_SHORT = "e?"
var PATTERN_AY = "%s%s?"  % [nc(PATTERN_A), nc(PATTERN_Y)]
var PATTERN_IY = "%s%s?" % [nc(PATTERN_I), nc(PATTERN_Y)]
var PATTERN_OY = "%s%s?" % [nc(PATTERN_O), nc(PATTERN_Y)]
var PATTERN_T = "t{1,2}h?"
var PATTERN_CH = "(sh)|(ch)|(s{0,2}%ss{0,2})" % nc(PATTERN_K)
var PATTERN_G = "g{1,2}"
var PATTERN_H = "h{0,2}"
var PATTERN_J = "(?:d?j{1,2})|(?:d?g)"
var PATTERN_MB = nc(PATTERN_M) + nc(PATTERN_B) + "?"
var PATTERN_MP = nc(PATTERN_M) + nc(PATTERN_P) + "?"
var PATTERN_MPF = "%s%s%s?%s" % [nc(PATTERN_M), nc(OPT_VOWEL), nc(PATTERN_P), nc(PATTERN_F)]
var PATTERN_NG = "%s{1,2}g?" % nc(PATTERN_N)
var PATTERN_NC = "%s{1,2}%s{0,2}|%s{0,2}%s{1,2}" % [nc(PATTERN_N), nc(PATTERN_K), nc(PATTERN_N), nc(PATTERN_K)]
var PATTERN_ND = "%s[dt]?" % nc(PATTERN_N)
var PATTERN_PS = "%s?%s" % [nc(PATTERN_P), nc(PATTERN_S)]
var PATTERN_V = nc(PATTERN_B) + "|" + nc(PATTERN_F) + "|v{1,2}"
var PATTERN_W = "w{1,2}|v{1,2}"
var PATTERN_X = "x|[cks]{1,2}"
var PATTERN_TS = "t*%s" % nc(PATTERN_S)


var LETTER_PATTERNS = {
	"R": PATTERN_R,
	"L": PATTERN_L,
	"K": PATTERN_K,
	"C": PATTERN_C,
	"M": PATTERN_M,
	"B": PATTERN_B,
	"P": PATTERN_P,
	"F": PATTERN_F,
	"N": PATTERN_N,
	"S": PATTERN_S,
	"D": PATTERN_D,
	"Y": PATTERN_Y,
	"E": PATTERN_E,
	"A": PATTERN_A,
	"I": PATTERN_I,
	"U": PATTERN_U,
	"O": PATTERN_O,
	"Ê": PATTERN_E_SHORT,
	"AY": PATTERN_AY,
	"OY": PATTERN_OY,
	"T": PATTERN_T,
	"CH": PATTERN_CH,
	"G": PATTERN_G,
	"H": PATTERN_H,
	"J": PATTERN_J,
	"MB": PATTERN_MB,
	"MP": PATTERN_MP,
	"MPF": PATTERN_MPF,
	"NG": PATTERN_NG,
	"NC": PATTERN_NC,
	"ND": PATTERN_ND,
	"PS": PATTERN_PS,
	"V": PATTERN_V,
	"W": PATTERN_W,
	"X" : PATTERN_X,
	"TS": PATTERN_TS,
	"Ş": PATTERN_S,
}

var API_LETTERS = {
	"R": "R",
	"L": "L",
	"K": "K",
	"C": "K",
	"M": "M",
	"B": "B",
	"P": "P",
	"F": "F",
	"N": "N",
	"S": "S",
	"D": "D",
	"Y": "Y",
	"E": "E",
	"A": "A",
	"I": "I",
	"U": "U",
	"O": "O",
	"Ê": "",
	"AY": "E",
	"OY": "O",
	"T": "T",
	"CH": "Ç",
	"G": "G",
	"H": "H",
	"J": "Ş",
	"MB": "M",
	"MP": "M",
	"MPF": "M",
	"NG": "N",
	"NC": "N",
	"ND": "N",
	"PS": "S",
	"V": "F",
	"W": "W",
	"X" : "S",
	"TS": "S",
	"Ş": "Ş",
}

var graphs = [
	["sh", "Ş"],
	["e$", "Ê"],
	["ie", "I"],
	["ii", "I"],
	["iie", "E"],
	["ei", "E"],
	["ai", "A"],
	["ee", "I"],
	["ae", "A"],
	["ea", "A"],
	["aé", "A"],
	["áe", "A"],
	["áé", "A"],
	["e", "E"],
	["é", "E"],
	["è", "E"],
	["a", "A"],
	["aa", "A"],
	["ao", "A"],
	["à", "A"],
	["á", "A"],
	["aw", "A"],
	["ew", "U"],
	["ay", "E"],
	["ey", "E"],
	["ah", "A"],
	["i", "I"],
	["ì", "I"],
	["í", "I"],
	["o", "O"],
	["ó", "O"],
	["ò", "O"],
	["oy", "OY"],
	["u", "U"],
	["ue", "E"],
	["oe", "O"],
	["ui", "I"],
	["uo", "O"],
	["oo", "U"],
	["ou", "U"],
	["b", "B"],
	["ss", "S"],
	["c", "C"],
	["sch", "Ş"],
	["t", "T"],
	["cc", "C"],
	["ch", "Ş"],
	["d", "D"],
	["dd", "D"],
	["f", "F"],
	["k", "K"],
	["g", "G"],
	["h", "H"],
	["j", "J"],
	["l", "L"],
	["l+", "L"],
	["m", "M"],
	["mb", "MB"],
	["mp", "MP"],
	["mpf", "MPF"],
	["n", "N"],
	["nn", "N"],
	["ng", "NG"],
	["nc", "NC"],
	["p", "P"],
	["r", "R"],
	["rr", "R"],
	["s", "S"],
	["ps", "PS"],
	["v", "V"],
	["w", "W"],
	["x", "X"],
	["ts", "TS"],
	["tz", "TS"],
	["z", "TS"],
	["th", "S"],
	["qu", "K"],
	["q", "K"],
	["y", "I"],
]

var DE_CONVOLUTE = [
	["pp", "p"],
	["aa", "a"],
	["ee", "i"],
	["oo", "u"],
	["ii", "i"],
	["iie", "i"],
	["ie", "i"],
	["uu", "u"],
	["chr", "kr"],
	["ian", "an"],
	["gh", ""],
	["bb", "b"],
	["au", "o"],
	["tt", "t"],
	["ss", "s"],
	["zz", "z"],
	["gn", "n"],
	["bd", "d"],
	["yn", "in"],
	["nn", "n"],
	["ph", "f"],
	["ll", "l"],
]

var DE_CONVOLUTE_HUMAN  = [
	["ce", "se"],
	["cé", "se"],
	["ci", "si"],
	["cy", "si"],
	["ge", "je"],
	["gé", "je"],
	["gia", "ja"],
]

func map_str(s, f):
	var ret = []
	for letter in s:
		ret.push_back(f.call(letter))
	return ret

func filter_str(s, f):
	var ret = []
	for letter in s:
		if f.call(letter):
			ret.push_back(letter)
	return ret

func get_pattern(data):
	var pattern_pieces = map_str(data, func(_i): return null)
	var matches = []
	var reg = null
	var already_matched = false
	for pair in graphs:
		reg = RegEx.new()
		reg.compile(LETTER_PATTERNS[pair[1]])
		if not reg.is_valid():
			return ["", ""]
		matches = reg.search_all("m" + data)
		if matches.size() == 0:
			continue
		for match_obj in matches:
			already_matched = false
			for i in range(match_obj.get_start(), match_obj.get_end()):
				if pattern_pieces[i - 1] != null:
					already_matched = true
					break
			if already_matched:
				continue
			pattern_pieces[match_obj.get_start() - 1] = nc(LETTER_PATTERNS[pair[1]])
			if match_obj.get_start() - 1 + 1 == match_obj.get_end() -1:
				continue
			for i in range(match_obj.get_start() -1 + 1, match_obj.get_end() - 1):
				pattern_pieces[i] = ""

	var unmatched = []
	for i in range(data.length()):
		if pattern_pieces[i] == null:
			unmatched.append(data[i])
	if unmatched.size() > 0:
		print("Couldn't understand some letters!", pattern_pieces, data)
		for l in unmatched:
			print("- %s" % l)

	return "".join(
		pattern_pieces.filter(func(x): return x != null)
	)


func _get_vowel_indeces(data):
	var vowel_starts = []
	var last_letter = ""
	var i = 0
	while i < data.length():
		if (
				(data[i] in VOWELS and not last_letter in VOWELS)
				or (data[i] == "y" and i + 1 == data.length())
		):
			vowel_starts.append(i)
		elif last_letter == "y" and (i < 2 or vowel_starts[-1] != i - 2):
			vowel_starts.append(i - 1)
		i += 1
	return vowel_starts

func get_greedy_syllables(data, vowels_at):
	var greedy_syllables = []
	var grab_before = []
	var body = []
	var i = 0
	while i < vowels_at.size():
		if i > 0:
			grab_before = [
				vowels_at[i-1] + 1,
				vowels_at[i],
			]
		else:
			grab_before = [
				0,
				vowels_at[i]
			]
		if vowels_at.size() - 1 == i:
			body = [
				vowels_at[i],
				data.length()
			]
		else:
			body = [
				vowels_at[i],
				vowels_at[i + 1] - 1,
			]
		greedy_syllables.append([grab_before, body])
		i += 1
	return greedy_syllables


func slice_str(s, start, end):
	var ret = ""
	var i = start
	while i < end:
		ret = ret + s[i]
		i += 1
	return ret

func get_structured_syllables_list(data):
	var vowels_at = _get_vowel_indeces(data)

	var greedy_syllables = get_greedy_syllables(data, vowels_at)
	if greedy_syllables.size() == 1:
		return [[data]]

	var structured_syllables = structured_syllables_from_greedy(greedy_syllables)

	return structured_syllables_to_strings(data, structured_syllables)

func structured_syllables_to_strings(data, structured):
	var ret = []
	for outer in structured:
		ret.push_back(_structured_syllables_to_strings(data, outer))
	return ret

func _structured_syllables_to_strings(data, outer):
	var ret = []
	var start = outer[0]
	for i in range(outer.size()):
		var inner = outer[i + 1] if i + 1 < outer.size() else null
		if (
			inner == null
			and typeof(outer[i]) == TYPE_INT 
			and start == outer[i]
		):
			inner = data.length()
		if inner == null:
			break
		if typeof(inner) == TYPE_INT:
			var end = inner
			ret.push_back(slice_str(data, start,end))
			if i < outer.size() - 1:
				start = inner
		else:
			var end = inner[0]
			ret.push_back(
				[slice_str(data, start, end)] + _structured_syllables_to_strings(data, inner)
			)
	return ret

func structured_syllables_from_greedy(greedy):
	if not greedy.size():
		return [[0]]
	var root = greedy[0]

	var root_permutations = []

	var mod = 0
	if greedy.size() == 1:
		while mod <= root[0][1] - root[0][0]:
			var variant = [root[0][0] + mod]
			root_permutations.push_back(variant)
			mod += 1
	else:
		while mod <= root[0][1] - root[0][0]:
			var variant = [root[0][0] + mod] + structured_syllables_from_greedy(greedy.slice(1))
			root_permutations.push_back(variant)
			mod += 1
	return root_permutations

func dedup(x: Array):
	var ret = []
	for item in x:
		if item not in ret:
			ret.push_back(item)
	return ret

func get_syllable_combinations(data):
	var structured = get_structured_syllables_list(data)
	var ret = []
	for starter in structured:
		for root in starter:
			if typeof(root) == TYPE_STRING:
				return [root]
			ret += _get_syllable_combinations(root, [])

	return dedup(ret)

func _get_syllable_combinations(root, bases):
	var next_base = root[0]
	var cur_bases = bases.map(func(base): return base + next_base)
	cur_bases.push_back(next_base)

	var new_roots = []
	if root.size() > 1:
		for item in root.slice(1):
			if typeof(item) == TYPE_STRING:
				new_roots += [item] + cur_bases.map(
					func(base): return base + item
				)
				continue
			new_roots += _get_syllable_combinations(item, cur_bases)

	return bases + cur_bases + new_roots


func intersect(array1, array2):
	var intersection = []
	for item in array1:
		if item in array2:
			intersection.append(item)
	return intersection


func get_names_from_patterns(patterns):
	var names = []
	var modpat = null
	var matcher = null
	for line in $NicknameList.NAMES:
		for pattern in patterns:
			modpat = pattern[1]
			if pattern[0].length() > 3:
				modpat += "?" + nc(OPT_VOWEL) + "$"
			else:
				modpat += nc(OPT_VOWEL) + "$"
			matcher = RegEx.new()
			matcher.compile(modpat)
			var all_matches = matcher.search_all(
				"m" + line.to_lower()
			)
			for matches in all_matches:
				if matches.get_start() != 1:
					continue
				names.append([
					(abs(line.length() - (matches.get_end() - matches.get_start()))),
					line,
					pattern[0].length(),
					intersect(pattern[0], line).size(),
					filter_str(
						line,
						func(l): return (
							l not in pattern[0] and l not in VOWELS_PERMISSIVE
						)
					).size(),
					filter_str(
						line,
						func(l): return (
							l in VOWELS and l in pattern[0]
						)
					).size(),
					pattern[0],
				])
	return names

func get_cleaned_names(data, names):
	var deduped_names = []
	var name_categories = {}
	names.sort_custom(func(a, b): return b[6].length() > a[6].length())
	for n in names:
		if (
			deduped_names.filter(
				func(m): return m[1] == n[1]
			).size() == 0
		):
			if not n[6] in name_categories:
				name_categories[n[6]] = []
			name_categories[n[6]].append(n)
			deduped_names.append(n)

	var cutoff = 2
	if name_categories.size() > 5:
		cutoff = 1
	elif name_categories.size() < 4 or deduped_names.size() < 12:
		cutoff = 3
	var categorized_names = []
	for key in name_categories:
		var sublist = name_categories[key]
		sublist.sort_custom(get_final_name_sort(data))
		categorized_names += sublist.slice(
			0, cutoff if sublist.size() > cutoff else sublist.size()
		)
	return categorized_names


func bump_first_letter_matches(data, categorized_names):
	categorized_names.sort_custom(get_final_name_sort(data))
	var initial_names = categorized_names.filter(
		func(n): return n[1][0].to_lower() == data[0]
	)
	var chosen_initial_names = initial_names.slice(
		0, 3 if initial_names.size() > 3 else initial_names.size()
	)
	for n in chosen_initial_names:
		categorized_names.erase(n)
	categorized_names = chosen_initial_names + categorized_names
	#for name in names:
	return categorized_names


func get_best_names(categorized_names):
	return categorized_names.slice(
		0,
		10 if categorized_names.size() > 10 else categorized_names.size()
	)

func get_cleaned_syllables(data):
	var syllables = get_syllable_combinations(data)
	if syllables.size() > 3:
		syllables = syllables.filter(
			func(syll): return syll.length() > 1
		)
	syllables.sort_custom(func(a, b): return b.length() > a.length())
	return syllables


func _sort_names_get_score(x):
	var val = x[4] + x[3] * 0.2  + x[2] + x[0] + x[6].length()
	if val < 0:
		return 0
	return val

func sort_names(a, b):
	return _sort_names_get_score(b) > _sort_names_get_score(a)

func deaccent(data):
	var acc = [
		["a", ["á", "à"]],
		["e", ["é", "è"]],
		["i", ["ì", "í"]],
		["o", ["ó", "ò"]],
		["u", ["ù", "ú"]],
	]
	for a in acc:
		for letter in a[1]:
			data = data.replacen(letter, a[0])
	return data

func _final_name_get_score(data, x):
	var score = x[6].length() - 0.1*x[0]
	if x[6].is_subsequence_of(deaccent(data)):
		score += 1000
	if x[2] > 5:
		score += 1000
	if data.ends_with(x[6]):
		score += 2
	if data.to_lower()[0] == x[6][0]:
		score += 5 * x[1].length()
	if x[1].to_lower()[0] == x[6][0]:
		score += 2 * x[1].length()
	return score

func get_final_name_sort(data):
	var final_name_sort = func(a, b):
		return _final_name_get_score(data, b) < _final_name_get_score(data, a)

	return final_name_sort

func search_by_pattern():
	graphs.sort_custom(func(a, b): return b[0].length() > a[0].length())

	var data = your_name

	data = data.to_lower()

	var syllables = get_cleaned_syllables(data)
	var patterns = syllables.map(
		func(syll): return [syll, get_pattern(syll)]
	)

	var names = get_names_from_patterns(patterns)
	
	if names == null:
		return
	names.sort_custom(sort_names)

	var categorized_names = get_cleaned_names(data, names)
	categorized_names = bump_first_letter_matches(data, categorized_names)

	return get_best_names(categorized_names)

func main():
	return search_by_index()
	
	# old, working func:
	# return search_by_pattern()

func search_by_index():
	var data = your_name
	
	return search_name(data)

func phoneticize(data, use_human=false):
	graphs.sort_custom(func(a, b): return b[0].length() > a[0].length())
	DE_CONVOLUTE.sort_custom(func(a, b): return b[0].length() > a[0].length())

	data = data.to_lower()
	data = data.replace("-", "")
	data = data.replace(" ", "")

	for pair in DE_CONVOLUTE + (DE_CONVOLUTE_HUMAN if use_human else []):
		data = data.replace(pair[0], pair[1])

	for pair in graphs:
		data = data.to_lower().replace(pair[0], API_LETTERS[pair[1]])

	data = data.to_lower()
	for pair in DE_CONVOLUTE + (DE_CONVOLUTE_HUMAN if use_human else []):
		data = data.replace(pair[0], pair[1])

	return data.to_lower()


func accentify(data: String):

	if data[-1] not in VOWELS:
		data += "ö"

	if data.length() < 4:
		return data

	var _name = data[0]
	var i = 1
	while i < data.length():
		if data[i] not in VOWELS and data[i-1] not in VOWELS:
			_name = _name + "ö" + data[i]
		else:
			_name += data[i]
		i += 1

	return _name

func get_phonetic(data, use_human=false):
	graphs.sort_custom(func(a, b): return b[0].length() > a[0].length())
	

	data = data.to_lower()

	data = phoneticize(data, use_human)

	data = accentify(data)

	return data


func get_phonetic_syllables(data, use_human=false):
	data = get_phonetic(data, use_human)
	var syllables = get_structured_syllables_list(data)
	return [syllables, data]


func _get_weighted_matches(
		main_ix, subdict, tok, remaining_tokens, depth, skip_vowel=false
):
	if tok not in subdict and remaining_tokens.size() == 1:
		return []
	if tok not in subdict and (skip_vowel or "ö" not in subdict):
		return _search_names(main_ix, main_ix, remaining_tokens.slice(1), 0)
	if tok not in subdict:
		var sub_names = []
		for n in subdict["ö"]["_"]:
			sub_names.push_back([n, depth])
		return (
		sub_names
		# + _search_names(main_ix, subdict["ö"], remaining_tokens.slice(1), depth + 1)
		# uncomment above to match names by non-initial parts
	)
	var sub_names = []
	for n in subdict[tok]["_"]:
		sub_names.push_back([n, depth*tok.length() + subdict[tok]["$"]])
	return (
		sub_names
		#+ _search_names(main_ix, subdict[tok], remaining_tokens.slice(1), depth * tok.length() + 1)
		# uncomment above to match names by non-initial parts
	)

func vaguify_vowels(data):
	var v = "[" + "".join(VOWELS) + "]+"
	var r = RegEx.create_from_string(v)
	return r.sub(data, "ö")


func _search_names(main_ix, subdict, remaining_tokens, depth):
	if not remaining_tokens:
		return []

	var tok = remaining_tokens[0]

	var vague_vowel_tok = vaguify_vowels(tok)

	return (
		_get_weighted_matches(
			main_ix, subdict, tok, remaining_tokens, depth
		) + _get_weighted_matches(
			main_ix, subdict, vague_vowel_tok, remaining_tokens, depth
		)
	)

func _flatten_syllables(subtree, cur_tree, trees):
	if typeof(subtree) == TYPE_STRING:
		trees.append(cur_tree + [subtree])
		return

	if subtree.size() == 1:
		trees.append(cur_tree + subtree.slice(1))
		return

	if typeof(subtree[1]) == TYPE_STRING:
		trees.append(cur_tree + subtree.slice(1))
		return

	for subsub in subtree.slice(1):
		_flatten_syllables(subsub, cur_tree + [subsub[0]], trees)


func flatten_syllables(subtree):
	var trees = []
	for root in subtree[0]:
		_flatten_syllables(root, [root[0]], trees)
	return trees

func search_name(data):
	var orig = data.to_lower()
	var _phon_ret = get_phonetic_syllables(data)
	var structured_syllables = _phon_ret[0]
	var phonetic_name = _phon_ret[1]
	var comb = flatten_syllables(structured_syllables)

	var matches = []

	var index_json = JSON.new()
	
	var index_raw = FileAccess.get_file_as_string(name_index)

	var parse_error = index_json.parse(index_raw)
	
	if parse_error != OK:
		return
	
	var index = index_json.data

	for n in comb:
		matches += _search_names(index, index, n, 0)

	var deduped_matches = {}
	for m in matches:
		if m[0] not in deduped_matches or deduped_matches[m[0]] < m[1]:
			deduped_matches[m[0]] = m[1]

	var sorted_matches = []
	for k in deduped_matches:
		var v = deduped_matches[k]
		sorted_matches.push_back([k, v])

	sorted_matches.sort_custom(func(a, b): return b[1] < a[1])
	#names.sort_custom(func(a, b): return b[6].length() > a[6].length())

	sorted_matches = get_most_letter_overlaps(sorted_matches, phonetic_name)
	sorted_matches.sort_custom(func(a, b): return b[1] < a[1])
	
	sorted_matches = pairs_to_name_case(sorted_matches)

	if sorted_matches.size() < 2:
		sorted_matches = sorted_matches + default_names_by_letter(orig[0])

	if sorted_matches.size() > 6:
		return sorted_matches.slice(0, 6)
	
	return sorted_matches

func default_names_by_letter(letter: String):
	var defaults = DEFAULT_NAMES.filter(func (x): return x if x[0].to_lower() == letter else false)
	var ret = []
	for d in defaults:
		ret.push_back([d, null])
	return ret

func pairs_to_name_case(pairs):
	for pair in pairs:
		var _name = pair[0]
		_name = _name.capitalize()
		var parts = _name.split("-")
		for part in parts:
			part = part.capitalize()
		_name = "-".join(parts)
		pair[0] = _name
	return pairs

func get_most_letter_overlaps(names, orig):
	var tally  = {}
	var letters = []
	for l in orig:
		if l not in letters:
			letters.push_back(l)

	for pair in names:
		var n = pair[0]
		var both = []
		for l in letters:
			if l in n:
				both.push_back(l)
		var count = 0
		for b in both:
			if b in VOWELS:
				count += 1
			else:
				count += 2
		if count not in tally:
			tally[count] = []
		tally[count].append(n)

	var seq = tally.keys()

	var best = []
	var i = 0
	while i < seq.size():
		best += tally[seq[i]]
		i += 1
	
	var ret = []
	for n in names:
		if n[0] in best:
			ret.push_back(n)
	
	return ret
