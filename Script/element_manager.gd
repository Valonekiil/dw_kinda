extends Node

class_name ElementSystem

# Definisi hubungan elemen (strength/weakness)
var element_relations = {
	"Neutral":{"strong": ["Mystical"]},
	"Fire": {"strong": ["Earth", "Ice", "Metal"], "weak": ["Water", "Lightning", "Nature", "Fire"]},
	"Water": {"strong": ["Fire", "Lightning", "Metal"], "weak": ["Earth", "Wind", "Nature"]},
	"Earth": {"strong": ["Water", "Lightning", "Nature"], "weak": ["Wind", "Ice", "Metal"]},
	"Wind": {"strong": ["Earth", "Ice", "Nature", "Water"], "weak": ["Fire", "Lightning", "Metal"]},
	"Lightning": {"strong": ["Water", "Wind", "Metal"], "weak": ["Earth", "Fire", "Nature"]},
	"Ice": {"strong": ["Wind", "Earth", "Nature"], "weak": ["Fire", "Lightning", "Metal"]},
	"Light": {"strong": ["Dark"], "weak": ["Dark", "Chaos"]},
	"Dark": {"strong": ["Light"], "weak": ["Light", "Chaos"]},
	"Nature": {"strong": ["Fire", "Water", "Earth"], "weak": ["Wind", "Ice", "Lightning"]},
	"Metal": {"strong": ["Ice", "Lightning", "Earth"], "weak": ["Fire", "Water", "Wind"]},
	"Chaos": {"strong": ["Mystical", "Light", "Dark"], "weak": ["Chaos"]},
	"Mystical": {"strong": ["Fire", "Water", "Earth", "Wind", "Lightning", "Ice", "Light", "Dark", "Nature", "Metal"], "weak": ["Chaos", "Neutral"]}
}

# Fungsi untuk menghitung damage multiplier berdasarkan elemen
func calculate_damage_multiplier(attacker_element: String, defender_element: String, defender_2nd_element: String) -> float:
	if defender_2nd_element != null:
		if defender_2nd_element in element_relations[attacker_element]["strong"]:
			if defender_element in element_relations[attacker_element]["strong"]:
				return 2.5
			elif defender_element in element_relations[attacker_element]["weak"]:
				return 1.5
			else :
				return 2.0
		elif defender_2nd_element in element_relations[attacker_element]["weak"]:
			if defender_element in element_relations[attacker_element]["strong"]:
				return 1.5
			elif defender_element in element_relations[attacker_element]["weak"]:
				return 0.25
			else :
				return 0.5
		else:
			if defender_element in element_relations[attacker_element]["strong"]:
				return 2.0
			elif defender_element in element_relations[attacker_element]["weak"]:
				return 0.5
			else :
				return 1.0
	else:
		if defender_element in element_relations[attacker_element]["strong"]:
			return 2 
		elif defender_element in element_relations[attacker_element]["weak"]:
			return 0.5  
		else:
			return 1.0  
