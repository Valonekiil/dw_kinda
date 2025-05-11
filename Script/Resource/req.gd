extends Resource
class_name Requirement

enum ReqType {
	LVL,
	POWER,
	GUARD,
	ARCANE,
	INSIGHT,
	SPEED,
	CHARM,
	FIRE,
	WATER,
	EARTH,
	NATURE,
	WIND,
	LIGHTNING,
	ICE,
	METAL,
	LIGHT,
	DARK,
	CHAOS,
	MYSTICAL
}

enum CompareOperator {
	GREATER_THAN,
	LESS_THAN,
	GREATER_EQUAL,
	LESS_EQUAL,
	EQUAL
}

@export var stat_name: ReqType
@export var comparison: CompareOperator
@export var value: int

func get_stat_name_string() -> String:
	match stat_name:
		ReqType.LVL: return "lvl"
		ReqType.POWER: return "power"
		ReqType.GUARD: return "guard"
		ReqType.ARCANE: return "arcane"
		ReqType.INSIGHT: return "insight"
		ReqType.SPEED: return "speed"
		ReqType.CHARM: return "charm"
		ReqType.FIRE: return "fire"
		ReqType.WATER: return "water"
		ReqType.EARTH: return "earth"
		ReqType.NATURE: return "nature"
		ReqType.WIND: return "wind"
		ReqType.LIGHTNING: return "lightning"
		ReqType.ICE: return "ice"
		ReqType.METAL: return "metal"
		ReqType.LIGHT: return "light"
		ReqType.DARK: return "dark"
		ReqType.CHAOS: return "chaos"
		ReqType.MYSTICAL: return "mystical"
	return ""

func is_met(stats: Stats_Source) -> bool:
	var stat_value = stats.get(get_stat_name_string())
	if stat_value == null:
		push_error("Stat %s tidak valid" % get_stat_name_string())
		return false
	
	match comparison:
		CompareOperator.GREATER_THAN: return stat_value > value
		CompareOperator.LESS_THAN: return stat_value < value
		CompareOperator.GREATER_EQUAL: return stat_value >= value
		CompareOperator.LESS_EQUAL: return stat_value <= value
		CompareOperator.EQUAL: return stat_value == value
	return false
