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

func calculate_damage_simple(user:Stats_Source, skill:SkillData) -> float:
	var damage:float = skill.formula.BaseDamage
	if skill.formula.IsPhysical:
		damage += user.power * skill.formula.ScalingPhysic
	if skill.formula.IsMagical:
		damage += user.arcane * skill.formula.ScalingMagic
	return damage

func calculate_damage_total(user:Stats_Source, target:Stats_Source, formula:Skill_Formula):
	var total:float
	if formula.IsPhysical:
		var power = float(user.power)
		var guard = float(target.guard)
		var ratio = guard / power  # Rasio guard terhadap power
		
		if ratio >= 2.0:
			total += 0.0
		elif ratio >= 1.5:
			total += 0.5
		elif ratio <= 0.75:
			total += 1.5
		elif ratio <= 0.5:
			total += 2.0
		else:
			total += 1.0
	if formula.IsMagical:
		var power = float(user.arcane)
		var guard = float(target.insight)
		var ratio = guard / power  # Rasio guard terhadap power
		
		if ratio >= 2.0:
			total += 0.0
		elif ratio >= 1.5:
			total += 0.5
		elif ratio <= 0.75:
			total += 1.5
		elif ratio <= 0.5:
			total += 2.0
		else:
			total += 1.0
	if formula.IsElemental:
		pass
