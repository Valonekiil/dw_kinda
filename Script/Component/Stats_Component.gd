extends Node
class_name Stats_Component

@export var growth_formula:GrowthFormula
@export var stats_source: Stats_Source  # Referensi ke Stats_Source

# Fungsi untuk menambah EXP
func add_exp(amount: int):
	stats_source.cur_exp += amount
	print("Mendapatkan " + str(amount) + " EXP! Total EXP: " + str(stats_source.cur_exp))
	check_level_up()

# Fungsi untuk mengecek apakah EXP cukup untuk level up
func check_level_up():
	while stats_source.cur_exp >= stats_source.max_exp:
		# Hitung sisa EXP setelah level up
		stats_source.cur_exp -= stats_source.max_exp
		level_up()

# Fungsi untuk melakukan level up
func level_up():
	stats_source.lvl += 1
	stats_source.max_exp = calculate_max_exp()  # Hitung EXP maksimum untuk level berikutnya

	# Tingkatkan statistik berdasarkan tipe Digimon dan elemen utama
	increase_stats()

	if stats_source.cur_exp > stats_source.max_exp:
		check_level_up()
	else:
		print("Level up! Sekarang Level " + str(stats_source.lvl))

# Fungsi pembantu untuk presisi 3 desimal
func add_with_precision(a: float, b: float) -> float:
	return snapped(a + b, 0.001)

# Fungsi untuk meningkatkan statistik
func increase_stats():
	# PERTUMBUHAN PERSENTASE (multiplikatif)
	stats_source.health = add_with_precision(stats_source.health, stats_source.health * growth_formula.health_growth)
	stats_source.mana = add_with_precision(stats_source.mana, stats_source.mana * growth_formula.mana_growth)
	stats_source.power = add_with_precision(stats_source.power, stats_source.power * growth_formula.power_growth)
	stats_source.guard = add_with_precision(stats_source.guard, stats_source.guard * growth_formula.guard_growth)
	stats_source.arcane = add_with_precision(stats_source.arcane, stats_source.arcane * growth_formula.arcane_growth)
	stats_source.insight = add_with_precision(stats_source.insight, stats_source.insight * growth_formula.insight_growth)
	stats_source.speed = add_with_precision(stats_source.speed, stats_source.speed * growth_formula.speed_growth)
	stats_source.charm = add_with_precision(stats_source.charm, stats_source.charm * growth_formula.charm_growth)
	
	# Elemental stat growth (persentase)
	var elements = [
		Enums.Element.Fire, Enums.Element.Water, Enums.Element.Earth,
		Enums.Element.Nature, Enums.Element.Wind, Enums.Element.Lighting,
		Enums.Element.Ice, Enums.Element.Metal, Enums.Element.Light,
		Enums.Element.Dark, Enums.Element.Chaos, Enums.Element.Mystical
	]
	
	for element in elements:
		var growth_rate = growth_formula.other_element_growth
		if element == stats_source.primary_element:
			growth_rate = growth_formula.primary_element_growth
		elif element == stats_source.secondary_element:
			growth_rate = growth_formula.secondary_element_growth
		
		var current_value = get_element_value(element)
		var increase = current_value * growth_rate
		set_element_value(element, add_with_precision(current_value, increase))

# Helper untuk mendapatkan nilai elemen
func get_element_value(element: Enums.Element) -> float:
	match element:
		Enums.Element.Fire: return stats_source.fire
		Enums.Element.Water: return stats_source.water
		Enums.Element.Earth: return stats_source.earth
		Enums.Element.Nature: return stats_source.nature
		Enums.Element.Wind: return stats_source.wind
		Enums.Element.Lighting: return stats_source.lightning
		Enums.Element.Ice : return stats_source.ice
		Enums.Element.Metal : return stats_source.metal
		Enums.Element.Light : return stats_source.light
		Enums.Element.Dark : return stats_source.dark
		Enums.Element.Chaos : return stats_source.chaos
		Enums.Element.Mystical : return stats_source.mystical
	return 0.0

# Helper untuk mengatur nilai elemen
func set_element_value(element: Enums.Element, value: float):
	match element:
		Enums.Element.Fire: stats_source.fire = value
		Enums.Element.Water: stats_source.water = value
		Enums.Element.Earth: stats_source.earth = value
		Enums.Element.Nature: stats_source.nature = value
		Enums.Element.Wind: stats_source.wind = value
		Enums.Element.Lighting: stats_source.lightning = value
		Enums.Element.Ice : stats_source.ice = value
		Enums.Element.Metal : stats_source.metal = value
		Enums.Element.Light : stats_source.light = value
		Enums.Element.Dark : stats_source.dark = value
		Enums.Element.Chaos : stats_source.chaos = value
		Enums.Element.Mystical : stats_source.mystical = value

# Fungsi untuk menghitung EXP maksimum berdasarkan level
func calculate_max_exp() -> int:
	return int(100 * pow(1.2, stats_source.lvl))  # Contoh: EXP maksimum meningkat 20% setiap level

# Fungsi untuk menyimpan perubahan ke resource
func save_stats():
	var save_path = "res://stats_resource.tres"  # Path untuk menyimpan resource
	ResourceSaver.save(stats_source, save_path)
	print("Statistik disimpan ke " + save_path)
