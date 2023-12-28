extends Node
	

func stem_text(t: String):
	t = t.to_lower()
	t = punct.sub(t, "", true)
	
	var toks = t.split(" ")
	
	var new_toks = []
	for tok in toks:
		var n = stem_token(tok)
		if n not in stop_words:
			new_toks.push_back(n)

	return " ".join(new_toks)

const step2list = {
	"ational" : "ate",
	"tional" : "tion",
	"enci" : "ence",
	"anci" : "ance",
	"izer" : "ize",
	"bli" : "ble",
	"alli" : "al",
	"entli" : "ent",
	"eli" : "e",
	"ousli" : "ous",
	"ization" : "ize",
	"ation" : "ate",
	"ator" : "ate",
	"alism" : "al",
	"iveness" : "ive",
	"fulness" : "ful",
	"ousness" : "ous",
	"aliti" : "al",
	"iviti" : "ive",
	"biliti" : "ble",
	"logi" : "log"
}

const step3list = {
	"icate" : "ic",
	"ative" : "",
	"alize" : "al",
	"iciti" : "ic",
	"ical" : "ic",
	"ful" : "",
	"ness" : ""
}

const c = "[^aeiou]"          # consonant
const v = "[aeiouy]"          # vowel
const C = c + "[^aeiouy]*"    # consonant sequence
const V = v + "[aeiou]*"      # vowel sequence

const mgr0 = "^(" + C + ")?" + V + C # [C]VC... is m>0
const meq1 = "^(" + C + ")?" + V + C + "(" + V + ")?$"  # [C]VC[V] is m=1
const mgr1 = "^(" + C + ")?" + V + C + V + C # [C]VCVC... is m>1
const s_v = "^(" + C + ")?" + v # vowel in stem

var punct = RegEx.create_from_string("[.?',!’‘\"]")

const stop_words = [
	"a",
	"the",
	"is",
	"are",
	"and",
	"this",
	"thi",
	"that",
	"it",
	"for",
	"of",
]

func stem_token(w: String):
	var stem
	var suffix
	var firstch
	var re
	var re2
	var re3
	var re4
	
	w = w.to_lower()
	w = punct.sub(w, "", true)
	
	if w.length() < 3:
		return w
	
	firstch = w.substr(0,1)
	
	if firstch == "y":
		w = firstch.to_upper() + w.substr(1)

	re = RegEx.new()
	re.compile("^(.+?)(ss|i)es$")
	re2 = RegEx.new()
	re2.compile("^(.+?)([^s])s$")
	
	if re.search(w) != null:
		w = re.sub(w, "$1$2")
	if re2.search(w) != null:
		w = re2.sub(w, "$1$2")
	
	re = RegEx.new()
	re.compile("^(.+?)eed$")
	re2 = RegEx.new()
	re2.compile("^(.+?)(ed|ing)$")
	
	if re.search(w) != null:
		var fp = re.search(w).strings
		re = RegEx.new()
		re.compile(mgr0)
		if re.search(fp[1]) != null:
				re = ".$"
				w = re.sub(w, "")

	elif re2.search(w) != null:
		var fp = re2.search(w).strings
		stem = fp[1]
		re2 = RegEx.new()
		re2.compile(s_v)
		if re2.search(fp[1]) != null:
			w = stem
			re2 = RegEx.new()
			re2.compile("(at|bl|iz)$")
			re3 = RegEx.new()
			re3.compile("([^aeiouylsz])\\1$")
			re4 = RegEx.new()
			re4.compile("^" + C + v + "[^aeiouwxy]$")
			if re2.search(w) != null:
				w = w + "e"
			elif re3.search(w) != null: 
				re = RegEx.new()
				re.compile(".$")
				w = re.sub(w, "")
			elif re4.search(w) != null:
				w = w + "e"

	# Step 2
	re = RegEx.new()
	re.compile("^(.+?)(ational|tional|enci|anci|izer|bli|alli|entli|eli|ousli|ization|ation|ator|alism|iveness|fulness|ousness|aliti|iviti|biliti|logi)$")
	if re.search(w) != null:
		var fp = re.search(w).strings
		stem = fp[1]
		suffix = fp[2];
		re = RegEx.new()
		re.compile(mgr0)
		if re.search(stem) != null:
			w = stem + step2list[suffix]

	# Step 3
	re = RegEx.create_from_string("^(.+?)(icate|ative|alize|iciti|ical|ful|ness)$")
	if re.search(w) != null:
		var fp = re.search(w).strings
		stem = fp[1]
		suffix = fp[2]
		re = RegEx.create_from_string(mgr0)
		if re.search(stem) != null:
			w = stem + step3list[suffix]
	
	# Step 4
	re = RegEx.create_from_string("^(.+?)(al|ance|ence|er|ic|able|ible|ant|ement|ment|ent|ou|ism|ate|iti|ous|ive|ize)$")
	re2 = RegEx.create_from_string("^(.+?)(s|t)(ion)$")
	if re.search(w) != null:
		var fp = re.search(w).strings
		stem = fp[1]
		re = RegEx.create_from_string(mgr1)
		if re.search(w) != null:
			w = stem
	elif re2.search(w) != null:
		var fp = re2.search(w).strings
		stem = fp[1] + fp[2]
		re2 = RegEx.create_from_string(mgr1)
		if re2.search(w) != null:
			w = stem
	
	# Step 5
	re = RegEx.create_from_string("^(.+?)e$")
	if re.search(w) != null:
		var fp = re.search(w).strings
		stem = fp[1]
		re = RegEx.create_from_string(mgr1)
		re2 = RegEx.create_from_string(meq1)
		re3 = RegEx.create_from_string("^" + C + v + "[^aeiouwxy]$")
		if (
			re.search(stem) != null
			or (re2.search(stem) != null and re3.search(stem) == null)
		):
			w = stem
		re = RegEx.create_from_string("ll$")
		re2 = RegEx.create_from_string(mgr1)

	if re.search(w) != null and re2.search(w) != null:
		re = RegEx.create_from_string(".$")
		w = re.sub(w,"")
	
	# and turn initial Y back to y
	
	if firstch == "y":
		w = firstch + w.substr(1)

	return w
