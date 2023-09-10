extends Node2D
@export var your_name = ""
signal names_loaded

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
		NAMES = nameset.map(func(x): return x[1])
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
var PATTERN_A = "a"#"[aeieéàáo]{1,3}[wy]?"
var PATTERN_I = "[iìieéè]{1,3}[y]?"
var PATTERN_U = "[uoùú]{1,3}[wh]?"
var PATTERN_O = "[oeóòô]{1,3}[wh]?"

var graphs = [
	["e$", "e?"],
	["ee", PATTERN_I],
	["ey", PATTERN_E],
	["ay", PATTERN_E],
	["ae", PATTERN_A],
	["aé", PATTERN_A],
	["áe", PATTERN_A],
	["áé", PATTERN_A],
	["e", PATTERN_A],
	["é", PATTERN_E],
	["è", PATTERN_E],
	["a", PATTERN_A],
	["ay","%s%s?"  % [nc(PATTERN_A), nc(PATTERN_Y)]],
	["aa", PATTERN_A],
	["à", PATTERN_A],
	["á", PATTERN_A],
	["aw", PATTERN_A],
	["ah", PATTERN_A],
	["i", PATTERN_I],
	["ì", PATTERN_I],
	["í", PATTERN_I],
	["iy", "%s%s?" % [nc(PATTERN_I), nc(PATTERN_Y)]],
	["o", PATTERN_O],
	["ó", PATTERN_O],
	["ò", PATTERN_O],
	["oy", "%s%s?" % [nc(PATTERN_O), nc(PATTERN_Y)]],
	["u", PATTERN_U],
	["oo", PATTERN_U],
	["ou", PATTERN_U],
	["b", PATTERN_B],
	["c", PATTERN_C],
	["t", "t{1,2}h?"],
	["cc", PATTERN_C],
	["ch", "(sh)|(ch)|(s{0,2}%ss{0,2})" % nc(PATTERN_K)],
	["d", PATTERN_D],
	["dd", PATTERN_D],
	["f", PATTERN_F],
	["k", PATTERN_K],
	["g", "g{1,2}"],
	["h", "h{0,2}"],
	["j", "(d?j{1,2})|(d?g)"],
	["l", PATTERN_L],
	["l+", PATTERN_L],
	["m", PATTERN_M],
	["mb", nc(PATTERN_M) + nc(PATTERN_B) + "?"],
	["mp", nc(PATTERN_M) + nc(PATTERN_P) + "?"],
	["mpf", "%s%s%s?%s" % [nc(PATTERN_M), nc(OPT_VOWEL), nc(PATTERN_P), nc(PATTERN_F)]],
	["n", PATTERN_N],
	["nn", PATTERN_N],
	["ng", "%s{1,2}g?" % nc(PATTERN_N)],
	["nc", "%s{1,2}%s{0,2}|%s{0,2}%s{1,2}" % [nc(PATTERN_N), nc(PATTERN_K), nc(PATTERN_N), nc(PATTERN_K)]],
	["nd", "%s[dt]?" % nc(PATTERN_N)],
	["nt", "%s[dt]?" % nc(PATTERN_N)],
	["p", PATTERN_P],
	["r", PATTERN_R],
	["rr", PATTERN_R],
	["s", PATTERN_S],
	["ps", "%s?%s}" % [nc(PATTERN_P), nc(PATTERN_S)]],
	["v", nc(PATTERN_B) + "|" + nc(PATTERN_F) + "|v{1,2}"],
	["w", "w{1,2}|v{1,2}"],
	["y", PATTERN_Y],
	["x", "x|[cks]{1,2}"],
	["ts", "t*%s" % nc(PATTERN_S)],
	["tz", "t*%s" % nc(PATTERN_S)],
	["z", "t?" + nc(PATTERN_S)],
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
		reg.compile(pair[1])
		if not reg.is_valid():
			print(pair, reg)
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
			pattern_pieces[match_obj.get_start() - 1] = nc(pair[1])
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

func main():
	graphs.sort_custom(func(a, b): return b[0].length() > a[0].length())

	var data = your_name

	data = data.to_lower()
	print(data)

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
