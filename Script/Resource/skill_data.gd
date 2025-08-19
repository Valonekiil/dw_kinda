extends Resource
class_name SkillData

# Informasi dasar skill
@export var skill_name: String = ""  # Nama skill
@export var requirements: Array[Requirement]
@export var formula: Skill_Formula
@export var element: Enums.Element  # Elemen skill (opsional)
@export var skill_type: Enums.SkillType  # Tipe skill (ofensif atau defensif)
@export var mana_cost: int
# Efek buff/debuff (opsional)
@export var buff: Buff_Data  # Resource untuk buff

# Deskripsi skill (opsional)
@export var description: String = ""

@export var sprite:Texture2D
@export var anim_A:Animation
@export var anim_B:Animation

func is_requirements_met(stats: Stats_Source) -> bool:
	for req in requirements:
		if not req.is_met(stats):
			return false
	return true
