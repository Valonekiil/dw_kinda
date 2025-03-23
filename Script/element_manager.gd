extends Node

class_name ElementSystem

# Definisi hubungan elemen (strength/weakness)
var element_relations = {
	"Fire": {"strong": ["Earth", "Ice", "Metal"], "weak": ["Water", "Lightning", "Nature"]},
	"Water": {"strong": ["Fire", "Lightning", "Metal"], "weak": ["Earth", "Wind", "Nature"]},
	"Earth": {"strong": ["Water", "Lightning", "Nature"], "weak": ["Wind", "Ice", "Metal"]},
	"Wind": {"strong": ["Earth", "Ice", "Nature"], "weak": ["Fire", "Lightning", "Metal"]},
	"Lightning": {"strong": ["Water", "Wind", "Metal"], "weak": ["Earth", "Fire", "Nature"]},
	"Ice": {"strong": ["Wind", "Earth", "Nature"], "weak": ["Fire", "Lightning", "Metal"]},
	"Light": {"strong": ["Dark"], "weak": ["Dark", "Chaos"]},
	"Dark": {"strong": ["Light"], "weak": ["Light", "Chaos"]},
	"Nature": {"strong": ["Fire", "Water", "Earth"], "weak": ["Wind", "Ice", "Lightning"]},
	"Metal": {"strong": ["Ice", "Lightning", "Earth"], "weak": ["Fire", "Water", "Wind"]},
	"Chaos": {"strong": ["Mystical", "Light", "Dark"], "weak": ["Chaos"]},
	"Mystical": {"strong": ["Fire", "Water", "Earth", "Wind", "Lightning", "Ice", "Light", "Dark", "Nature", "Metal"], "weak": ["Chaos"]}
}

# Fungsi untuk menghitung damage multiplier berdasarkan elemen
func calculate_damage_multiplier(attacker_element: String, defender_element: String) -> float:
	if defender_element in element_relations[attacker_element]["strong"]:
		return 1.5  # Damage meningkat 1.5x jika kuat
	elif defender_element in element_relations[attacker_element]["weak"]:
		return 0.5  # Damage berkurang 0.5x jika lemah
	else:
		return 1.0  # Damage normal jika netral
