extends Resource
class_name SkillData

# Informasi dasar skill
@export var skill_name: String = ""  # Nama skill
@export var power: int # Kekuatan skill
@export var element: Enums.Element  # Elemen skill (opsional)
@export var skill_type: Enums.SkillType  # Tipe skill (ofensif atau defensif)

# Efek buff/debuff (opsional)
@export var buff: BuffData  # Resource untuk buff
@export var debuff: DebuffData  # Resource untuk debuff

# Deskripsi skill (opsional)
@export var description: String = ""
