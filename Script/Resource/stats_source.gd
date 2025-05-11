extends Resource
class_name Stats_Source
#lvl, 
@export var lvl: int
@export var monster_type: Enums.MonsterType
@export var primary_element: Enums.Element
@export var secondary_element: Enums.Element
@export var cur_exp: int
@export var max_exp: int
@export var health: int
@export var cur_hp: int
@export var mana: int
@export var cur_mana: int
@export var power: int
@export var guard: int
@export var arcane: int
@export var insight: int
@export var speed: int
@export var charm: int
@export var fire: int
@export var water: int
@export var earth: int
@export var nature: int
@export var wind: int
@export var lightning: int
@export var ice: int
@export var metal: int
@export var light: int
@export var dark: int
@export var chaos: int
@export var mystical: int

# Fungsi untuk menggabungkan dua Stats_Source
func apply_add(base: Stats_Source, add: Stats_Source) -> Stats_Source:
	var new_stat = Stats_Source.new()

	# Salin properti yang tidak diubah
	new_stat.lvl = base.lvl
	new_stat.digimon_type = base.digimon_type
	new_stat.primary_element = base.primary_element
	new_stat.secondary_element = base.secondary_element

	# Hitung pengurangan statistik berdasarkan tipe Digimon
	var reduction_multiplier = get_reduction_multiplier(base.digimon_type)

	# Gabungkan statistik dengan pengurangan
	new_stat.health = base.health + int(add.health * reduction_multiplier)
	new_stat.cur_hp = base.cur_hp + int(add.cur_hp * reduction_multiplier)
	new_stat.mana = base.mana + int(add.mana * reduction_multiplier)
	new_stat.cur_mana = base.cur_mana + int(add.cur_mana * reduction_multiplier)
	new_stat.power = base.power + int(add.power * reduction_multiplier)
	new_stat.guard = base.guard + int(add.guard * reduction_multiplier)
	new_stat.arcane = base.arcane + int(add.arcane * reduction_multiplier)
	new_stat.insight = base.insight + int(add.insight * reduction_multiplier)
	new_stat.speed = base.speed + int(add.speed * reduction_multiplier)
	new_stat.charm = base.charm + int(add.charm * reduction_multiplier)
	new_stat.fire = base.fire + int(add.fire * reduction_multiplier)
	new_stat.water = base.water + int(add.water * reduction_multiplier)
	new_stat.earth = base.earth + int(add.earth * reduction_multiplier)
	new_stat.nature = base.nature + int(add.nature * reduction_multiplier)
	new_stat.wind = base.wind + int(add.wind * reduction_multiplier)
	new_stat.lightning = base.lightning + int(add.lightning * reduction_multiplier)
	new_stat.ice = base.ice + int(add.ice * reduction_multiplier)
	new_stat.metal = base.metal + int(add.metal * reduction_multiplier)
	new_stat.light = base.light + int(add.light * reduction_multiplier)
	new_stat.dark = base.dark + int(add.dark * reduction_multiplier)
	new_stat.chaos = base.chaos + int(add.chaos * reduction_multiplier)
	new_stat.mystical = base.mystical + int(add.mystical * reduction_multiplier)

	return new_stat

# Fungsi untuk mendapatkan pengurangan berdasarkan tipe Digimon
func get_reduction_multiplier(digimon_type: Enums.MonsterType) -> float:
	match digimon_type:
		Enums.MonsterType.Deity:
			return 0.5  # Deity: 50%
		Enums.MonsterType.Mythos:
			return 0.6  # Mythos: 40%
		Enums.MonsterType.Majestic:
			return 0.7  # Majestic: 30%
		Enums.MonsterType.Mythical:
			return 0.8  # Mythical: 20%
		Enums.MonsterType.Mythling:
			return 0.9  # Mythling: 10%
		Enums.MonsterType.Echo:
			return 1.0  # Echo: 0% (tidak ada pengurangan)
		_:
			return 1.0  # Default: tidak ada pengurangan
