extends Node
class_name Stats_Component

@export var stats_source: Stats_Source  # Referensi ke Stats_Source

# Faktor pengali berdasarkan fase evolusi
var evolution_multipliers = {
	Enums.MonsterType.Echo: 1.0,
	Enums.MonsterType.Mythling: 2.0,
	Enums.MonsterType.Mythical: 5.0,
	Enums.MonsterType.Majestic: 7.0,
	Enums.MonsterType.Mythos: 8.0,
	Enums.MonsterType.Deity: 10.0
}

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

	# Dapatkan faktor pengali berdasarkan fase evolusi
	var multiplier = evolution_multipliers.get(stats_source.digimon_type, 1.0)

	# Tingkatkan statistik berdasarkan tipe Digimon dan elemen utama
	increase_stats(multiplier)

	if stats_source.cur_exp > stats_source.max_exp:
		check_level_up()
	else:
		print("Level up! Sekarang Level " + str(stats_source.lvl))

# Fungsi untuk meningkatkan statistik
func increase_stats(multiplier: float):
	# Statistik dasar
	stats_source.health += int(10 * multiplier)
	stats_source.mana += int(5 * multiplier)
	stats_source.power += int(2 * multiplier)
	stats_source.guard += int(2 * multiplier)
	stats_source.arcane += int(1 * multiplier)
	stats_source.insight += int(1 * multiplier)
	stats_source.speed += int(1 * multiplier)
	stats_source.charm += int(1 * multiplier)

	# Tingkatkan statistik elemen utama lebih tinggi
	match stats_source.primary_element:
		Enums.Element.Fire:
			stats_source.fire += int(3 * multiplier)
		Enums.Element.Water:
			stats_source.water += int(3 * multiplier)
		Enums.Element.Earth:
			stats_source.earth += int(3 * multiplier)
		Enums.Element.Nature:
			stats_source.nature += int(3 * multiplier)
		Enums.Element.Wind:
			stats_source.wind += int(3 * multiplier)
		Enums.Element.Lighting:
			stats_source.lightning += int(3 * multiplier)
		Enums.Element.Ice:
			stats_source.ice += int(3 * multiplier)
		Enums.Element.Metal:
			stats_source.metal += int(3 * multiplier)
		Enums.Element.Light:
			stats_source.light += int(3 * multiplier)
		Enums.Element.Dark:
			stats_source.dark += int(3 * multiplier)
		Enums.Element.Chaos:
			stats_source.chaos += int(3 * multiplier)
		Enums.Element.Mystical:
			stats_source.mystical += int(3 * multiplier)
		_:
			print("Elemen utama tidak dikenali.")

# Fungsi untuk menghitung EXP maksimum berdasarkan level
func calculate_max_exp() -> int:
	return int(100 * pow(1.2, stats_source.lvl))  # Contoh: EXP maksimum meningkat 20% setiap level

# Fungsi untuk menyimpan perubahan ke resource
func save_stats():
	var save_path = "res://stats_resource.tres"  # Path untuk menyimpan resource
	ResourceSaver.save(stats_source, save_path)
	print("Statistik disimpan ke " + save_path)
