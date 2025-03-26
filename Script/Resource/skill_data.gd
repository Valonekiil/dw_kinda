extends Resource
class_name SkillData

# Informasi dasar skill
@export var skill_name: String = ""  # Nama skill
@export var power: int # Kekuatan skill
@export var element: Enums.Element  # Elemen skill (opsional)
@export var skill_type: Enums.SkillType  # Tipe skill (ofensif atau defensif)

# Efek buff/debuff (opsional)
@export var buff: Buff_Data  # Resource untuk buff

# Deskripsi skill (opsional)
@export var description: String = ""
