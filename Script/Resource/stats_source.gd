extends Resource
class_name Stats_Source
#lvl, 
@export var lvl: int
@export var monster_type: Enums.MonsterType
@export var primary_element: Enums.Element
@export var secondary_element: Enums.Element
@export var cur_exp: int
@export var max_exp: int
@export var health: float
@export var cur_hp: int
@export var mana: float
@export var cur_mana: int
@export var power: float
@export var guard: float
@export var arcane: float
@export var insight: float
@export var speed: float
@export var charm: float
@export var fire: float
@export var water: float
@export var earth: float
@export var nature: float
@export var wind: float
@export var lightning: float
@export var ice: float
@export var metal: float
@export var light: float
@export var dark: float
@export var chaos: float
@export var mystical: float

func add_with_precision(a: float, b: float) -> float:
	return snapped(a + b, 0.001)

# Fungsi untuk menggabungkan dua Stats_Source
func apply_add(base: Stats_Source, add: Stats_Source) -> Stats_Source:
	var new_stat = Stats_Source.new()
	
	# Fungsi pembantu untuk penambahan dengan presisi
	
	# Salin properti yang tidak diubah
	new_stat.lvl = base.lvl
	new_stat.monster_type = base.monster_type
	new_stat.primary_element = base.primary_element
	new_stat.secondary_element = base.secondary_element
	
	var multiplier = get_reduction_multiplier(add.digimon_type)
	
	# Gabungkan statistik dengan presisi 3 desimal
	new_stat.health = add_with_precision(base.health, add.health * multiplier)
	new_stat.cur_hp = add_with_precision(base.cur_hp, add.cur_hp * multiplier)
	new_stat.mana = add_with_precision(base.mana, add.mana * multiplier)
	new_stat.cur_mana = add_with_precision(base.cur_mana, add.cur_mana * multiplier)
	new_stat.power = add_with_precision(base.power, add.power * multiplier)
	new_stat.guard = add_with_precision(base.guard, add.guard * multiplier)
	new_stat.arcane = add_with_precision(base.arcane, add.arcane * multiplier)
	new_stat.insight = add_with_precision(base.insight, add.insight * multiplier)
	new_stat.speed = add_with_precision(base.speed, add.speed * multiplier)
	new_stat.charm = add_with_precision(base.charm, add.charm * multiplier)
	new_stat.fire = add_with_precision(base.fire, add.fire * multiplier)
	new_stat.water = add_with_precision(base.water, add.water * multiplier)
	new_stat.earth = add_with_precision(base.earth, add.earth * multiplier)
	new_stat.nature = add_with_precision(base.nature, add.nature * multiplier)
	new_stat.wind = add_with_precision(base.wind, add.wind * multiplier)
	new_stat.lightning = add_with_precision(base.lightning, add.lightning * multiplier)
	new_stat.ice = add_with_precision(base.ice, add.ice * multiplier)
	new_stat.metal = add_with_precision(base.metal, add.metal * multiplier)
	new_stat.light = add_with_precision(base.light, add.light * multiplier)
	new_stat.dark = add_with_precision(base.dark, add.dark * multiplier)
	new_stat.chaos = add_with_precision(base.chaos, add.chaos * multiplier)
	new_stat.mystical = add_with_precision(base.mystical, add.mystical * multiplier)
	
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
